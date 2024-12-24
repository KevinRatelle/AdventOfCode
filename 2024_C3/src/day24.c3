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

fn bool Circuit.tick(Circuit* this)
{
    this.compute_signals();
    return this.compute_gates();
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

    ulong out;
    String[] keys = circuit.wires.tcopy_keys();
    foreach(key : keys)
    {
        if (key[0] != 'z')
        {
            continue;
        }

        ulong! index = key[1..].to_ulong();
        if (catch err = index)
        {
            continue;
        }

        Wire! wire = circuit.wires.get(key);
        if (catch err = wire)
        {
            continue;
        }

        ulong val = wire.value == Signal.TRUE ? 1 : 0;
        out += (val << index);
    }

    io::printfn("Got out %d", out);
}