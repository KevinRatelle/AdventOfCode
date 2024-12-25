import std::io;
import std::collections::list;
import std::collections::map;

enum Signal
{
    UNSET,
    TRUE,
    FALSE
}

enum Type
{
    AND,
    XOR,
    OR
}

fn Type get_type(String name)
{
    if (name == "AND")
    {
        return Type.AND;
    }

    if (name == "OR")
    {
        return Type.OR;
    }

    return Type.XOR;
}

struct Connection
{
    uint gate;
    bool is_a;
}

struct Wire
{
    Signal value;
    List(<Connection>) gates;
}

struct Gate
{
    Type type;
    Signal a;
    Signal b;
    bool set;

    String wire;
}

fn Signal Gate.compute(Gate* this)
{
    bool result;

    switch(this.type)
    {
        case Type.AND:
        {
            result = this.a == Signal.TRUE && this.b == Signal.TRUE;
        }
        case Type.OR:
        {
            result = this.a == Signal.TRUE || this.b == Signal.TRUE;
        }
        case Type.XOR:
        {
            result = this.a != this.b;
        }
    }

    return result ? Signal.TRUE : Signal.FALSE;
}

struct Circuit
{
    List(<Gate>) gates;
    HashMap(<String, Wire>) wires;
}

fn void Circuit.set_wire(Circuit* this, String wire_name, Connection gate)
{
    if (!this.wires.has_key(wire_name))
    {
        Wire wire;
        wire.value = Signal.UNSET;
        this.wires.set(wire_name, wire);
    }

    Wire*! wire = this.wires.get_ref(wire_name);
    if (catch err = wire)
    {
        return;
    }

    wire.gates.push(gate);
}

fn bool Circuit.compute_gates(Circuit* this)
{
    bool has_unset = false;
    foreach(&gate : this.gates)
    {
        if (gate.set)
        {
            continue;
        }

        has_unset = true;

        if (gate.a == Signal.UNSET || gate.b == Signal.UNSET)
        {
            continue;
        }

        gate.set = true;

        Signal signal = gate.compute();
        Wire*! wire = this.wires.get_ref(gate.wire);
        if (catch err = wire)
        {
            continue;
        }
        
        wire.value = signal;
    }

    return has_unset;
}

fn void Circuit.compute_signals(Circuit* this)
{
    Wire[] wires = this.wires.value_tlist();
    foreach(&wire : wires)
    {
        if (wire.value != Signal.UNSET)
        {
            foreach(connection : wire.gates)
            {
                if (connection.is_a)
                {
                    this.gates[connection.gate].a = wire.value;
                }
                else
                {
                    this.gates[connection.gate].b = wire.value;
                }
            }
        }
    }
}

fn ulong Circuit.run_and_compute_output(Circuit* this)
{
    while(this.tick())
    {
    }

    return this.compute_output('z');
}

fn bool Circuit.tick(Circuit* this)
{
    this.compute_signals();
    return this.compute_gates();
}

fn ulong Circuit.compute_output(Circuit* this, char in)
{
    ulong out = 0;

    String[] keys = this.wires.tcopy_keys();
    foreach(key : keys)
    {
        if (key[0] != in)
        {
            continue;
        }

        uint! index = key[1..].to_uint();
        if (catch err = index)
        {
            continue;
        }

        Wire! wire = this.wires.get(key);
        if (catch err = wire)
        {
            continue;
        }

        ulong val = wire.value == Signal.TRUE ? 1 : 0;
        out += (val << index);
    }

    return out;
}

fn uint Circuit.count_gates(Circuit* this, Type type)
{
    uint count = 0;
    foreach(Gate gate : this.gates)
    {
        if (gate.type == type)
        {
            count++;
        }
    }

    return count;
}

fn bool is_on(ulong val, uint bit)
{
    uint bit_total = $sizeof(val) * 8;
    ulong out = (val << (bit_total - bit - 1)) >> (bit_total - 1);
    return out != 0;
}

fn void Circuit.set_inputs(Circuit* this, ulong x, ulong y)
{
    // set ALL to UNSET, then set Xs and then Ys
    String[] keys = this.wires.tcopy_keys();
    foreach(key : keys)
    {
        Wire*! wire = this.wires.get_ref(key);
        if (catch err = wire)
        {
            continue;
        }

        bool isX = key[0] == 'x';
        bool isY = key[0] == 'y';
        if (!isX && !isY)
        {
            wire.value = Signal.UNSET;
            continue;
        }


        uint! bit = key[1..].to_uint();
        if(catch err = bit)
        {
            continue;
        }

        ulong val = isX ? x : y;
        wire.value = is_on(val, bit) ? Signal.TRUE : Signal.FALSE;
    }

    foreach(i, gate : this.gates)
    {
        this.gates[i].a = Signal.UNSET;
        this.gates[i].b = Signal.UNSET;
        this.gates[i].set = false;
    }
}

fn void Circuit.find_issues(Circuit* this)
{
    // after inspection, I see 45 bit for X, 45 bit for Y and 46 bit for Z output
    // I expect its a 45 bit adder + 1 bit carry for the output
    // usual version of full adder is made up of 2xN XOR gates, 2xN AND gates and 1xN OR gates = 5n gates
    // for 45 bit, it's about 225 gates, but I see only 222. It means they do not have a carry bit
    // for the inputs (which does not appear so from X, Y and problem statement)
    // so the first adder is not a full adder, it's a half adder, using 1 xor and 1 and gate.

    // I expect thus : 2x44 + 1 XOR, 2x44 AND + 1 and 44 OR, for a total of 89 + 89 + 44 = 178 + 44 = 222
    assert(this.count_gates(Type.XOR) == 89);
    assert(this.count_gates(Type.AND) == 89);
    assert(this.count_gates(Type.OR) == 44);

    // my idea is to try to add 1 and 1, and then multiple of 2s, it should isolate each full adder
    // by adding 1 and 1, we test only the half-adder, by adding 2 and 2, we test only the 1st full-adder
    // then, by knowing which bits are wrong, we'll see what to do
    uint offset = 0;
    while (offset < 44)
    {
        ulong in = ((ulong)1 << offset);

        this.set_inputs(in, in);
        ulong outx = this.compute_output('x');
        ulong outy = this.compute_output('y');
        ulong out = this.run_and_compute_output();
        io::printfn("Got output %d + %d = %d (expected %d)", outx, outy, out, outx+outy);

        offset++;
    }

    // THE REST WAS DONE MANUALLY BY CHEKING THE CIRCUIT AROUND THE WRONG OUTPUTS FOR EACH BIT
    // I'LL TRY TO GET SOMETHING AUTOMATED IF IT IS POSSIBLE BUT IT SEEMS HARD
    // SOLUTION FOUND : cpm,ghp,gpr,krs,nks,z10,z21,z33

}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    Circuit circuit;
    bool reading_inputs = true;
    foreach(line : lines)
    {
        if (line == "")
        {
            reading_inputs = false;
            continue;
        }

        if (reading_inputs)
        {
            String[] wire_data = line.split(": ");
            defer free(wire_data);

            Wire wire;
            wire.value = wire_data[1] == "1" ? Signal.TRUE : Signal.FALSE;
            circuit.wires.set(wire_data[0], wire);
        }
        else
        {
            String[] gate_data = line.split(" ");
            defer free(gate_data);

            assert(gate_data.len == 5);
            assert(gate_data[3] == "->");

            String a = gate_data[0];
            String b = gate_data[2];
            String out = gate_data[4];
            String type = gate_data[1];

            Gate gate;
            gate.wire = out;
            gate.type = get_type(type);
            gate.a = Signal.UNSET;
            gate.b = Signal.UNSET;
            gate.set = false;

            circuit.gates.push(gate);
            Connection connection;
            connection.gate = (uint) circuit.gates.len() - 1;
            connection.is_a = true;
            circuit.set_wire(a, connection);
            connection.is_a = false;
            circuit.set_wire(b, connection);

            if (!circuit.wires.has_key(out))
            {
                Wire wire;
                wire.value = Signal.UNSET;
                circuit.wires.set(out, wire);
            }
        }
    }


    if (!is_part_b)
    {
        ulong out = circuit.run_and_compute_output();
        io::printfn("Got out %d", out);
    }
    else
    {
        circuit.find_issues();
    }
}