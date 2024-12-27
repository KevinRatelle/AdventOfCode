import std::io;
import std::collections::list;
import std::collections::map;
import std::math::random;

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
    uint tick_count = 0;
    while(this.tick())
    {
        if (tick_count++ > 150)
        {
            return -1;
        }
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

fn void Circuit.swap_gate_output(Circuit* this, String a, String b)
{
    foreach(&gate : this.gates)
    {
        if (gate.wire == a)
    	{
            gate.wire = b;
        }
        else if (gate.wire == b)
        {
            gate.wire = a;
        }
    }
}

fn uint Circuit.get_connection(Circuit* this, String wire_name, Type gate_type)
{
    String[] keys = this.wires.tcopy_keys();
    foreach(key : keys)
    {
        if (key != wire_name)
        {
            continue;
        }

        Wire! wire = this.wires.get(key);
        if (catch err = wire)
        {
            continue;
        }

        foreach(connection : wire.gates)
        {
            if (this.gates[connection.gate].type == gate_type)
            {
                return connection.gate;
            }
        }
    }

    return 0;
}

fn uint[2] Circuit.check_gates_sum(Circuit* this, uint gate_index)
{
    // note : index in the schematic, not in the gate list
    uint[2] out;

    char[3] buf;
    String! y = (String) io::bprintf(&buf, "y%0.2d", gate_index);
    if (catch err = y)
    {
        return out;
    }

    out[0] = this.get_connection(y, Type.XOR);

    String other = this.gates[out[0]].wire;
    out[1] = this.get_connection(other, Type.XOR);

    return out;
}

fn uint[3] Circuit.check_gates_carry(Circuit* this, uint gate_index, String* carry)
{
    // note : index in the schematic, not in the gate list
    uint[3] out;

    char[3] buf;
    String! y = (String) io::bprintf(&buf, "y%0.2d", gate_index);
    if (catch err = y)
    {
        return out;
    }

    out[0] = this.get_connection(y, Type.AND);

    String other = this.gates[out[0]].wire;
    out[1] = this.get_connection(other, Type.OR);
    out[2] = this.get_connection(*carry, Type.AND);

    *carry = this.gates[out[1]].wire;

    return out;
}

struct Swap
{
    uint a;
    uint b;
}

fn bool Swap.equals(Swap* this, Swap other)
{
    return this.a == other.a && this.b == other.b ||
           this.b == other.a && this.a == other.b;
}

fn uint to_value(String a)
{
    return a[0] << 16 + a[1] << 8 + a[2];
}

fn String[8] sort_output(String[8] in)
{
    String[8] sorted;

    for(int i = 0; i < 8; i++)
    {
        uint index = 0;
        uint smallest = uint.max;
        for (int j = 0; j < 8; j++)
        {
            if (in[j] == "")
            {
                continue;
            }

            uint value = to_value(in[j]);
            if (value < smallest)
            {
                smallest = value;
                index = j;
            }
        }

        sorted[i] = in[index];
        in[index] = "";
    }

    return sorted;
}

fn void Circuit.find_issues(Circuit* this, bool verbose)
{
    // From inspection of the data :
    // Adder of 44 bit integers, with a carry bit out, but not in, so it contains:
    //      - 2 44 bit inputs, 1 45 bit output
    //      - 44 full adders
    //      - 1 half adder (first bit)
    // This adds up to:
    assert(this.count_gates(Type.XOR) == 89);
    assert(this.count_gates(Type.AND) == 89);
    assert(this.count_gates(Type.OR) == 44);

    // We can test each full adder by adding number containing a single bit
    List(<uint>) wrong_gates_queue;
    for(uint i = 0; i < this.gates.len(); i++)
    {
        wrong_gates_queue.push(i);
    }

    uint offset = 0;
    String carry;
    List(<Swap>) wrong_gates;

    if (verbose)
    {
        io::printfn("Step 1 : Finding gate pairs that can be wrong.");
    }

    while (offset < 44)
    {
        ulong inx = ((ulong)1 << offset);
        ulong iny = 0;
        ulong expected = inx + iny;

        this.set_inputs(inx, iny);
        ulong out = this.run_and_compute_output();

        if (offset == 0)
        {
            // assume the only half-adder is right
            assert(out == expected);
            
            String x = "x00";
            String y = "y00";
            
            Wire! wireX = this.wires.get(x);
            if (catch err = wireX)
            {
                continue;
            }

            Wire! wireY = this.wires.get(y);
            if (catch err = wireY)
            {
                continue;
            }

            assert(wireX.gates.len() == 2);
            assert(wireY.gates.len() == 2);
            ulong[2] gate_index_saved = {0,0};
            bool has_z00_out = false;
            foreach(gate_index : wireX.gates)
            {
                Gate gate = this.gates[gate_index.gate];
                if (gate.wire == "z00")
                {
                    has_z00_out = true;
                    gate_index_saved[0] = gate_index.gate;
                }
                else
                {
                    gate_index_saved[1] = gate_index.gate;
                    carry = gate.wire;
                }
            }

            assert(has_z00_out);

            has_z00_out = false;

            int ii = 0;
            foreach(gate_index : wireY.gates)
            {
                Gate gate = this.gates[gate_index.gate];
                if (gate.wire == "z00")
                {
                    gate_index_saved[0] = gate_index.gate;
                    has_z00_out = true;
                }
                else
                {
                    gate_index_saved[1] = gate_index.gate;
                    assert(carry == gate.wire);
                }
            }
            assert(has_z00_out);

            if (gate_index_saved[0] > gate_index_saved[1])
            {
                wrong_gates_queue.remove_at(gate_index_saved[0]);
                wrong_gates_queue.remove_at(gate_index_saved[1]);
            }
            else
            {
                wrong_gates_queue.remove_at(gate_index_saved[1]);
                wrong_gates_queue.remove_at(gate_index_saved[0]);
            }
        }
        else if (expected == out)
        {
            {
                uint[2] affected_gates = this.check_gates_sum(offset);

                for(int i = (int)wrong_gates_queue.len() - 1; i>=0; i--)
                {
                    if (wrong_gates_queue[i] == affected_gates[0] ||
                        wrong_gates_queue[i] == affected_gates[1])
                    {
                        wrong_gates_queue.remove_at(i);
                    }
                }
            }
        }
        else
        {

            uint[2] affected_gates = this.check_gates_sum(offset);
            foreach(gate : affected_gates)
            {
                String a = this.gates[gate].wire;
                for(int i = (int)wrong_gates_queue.len() - 1; i>=0; i--)
                {
                    String b = this.gates[wrong_gates_queue[i]].wire;
                    this.set_inputs(inx, iny);
                    this.swap_gate_output(a,b);
                    if (this.run_and_compute_output() == expected)
                    {
                        Swap swap;
                        swap.a = gate;
                        swap.b = wrong_gates_queue[i];
                        if (!wrong_gates.contains(swap))
                        {
                            wrong_gates.push(swap);
                        }
                    }
                    this.swap_gate_output(b,a);
                }
            }

            if (verbose)
            {
                io::printfn("   - Wrong bit found %d.", offset);
            }
        }

        inx = ((ulong)1 << offset);
        iny = inx;
        expected = inx + iny;

        this.set_inputs(inx, iny);
        out = this.run_and_compute_output();

        if (expected == out)
        {
            uint[3] affected_gates = this.check_gates_carry(offset, &carry);

            for(int i = (int)wrong_gates_queue.len() - 1; i>=0; i--)
            {
                if (wrong_gates_queue[i] == affected_gates[0] ||
                    wrong_gates_queue[i] == affected_gates[1] ||
                    wrong_gates_queue[i] == affected_gates[2])
                {
                    wrong_gates_queue.remove_at(i);
                }
            }
        }
        else
        {

            uint[3] affected_gates = this.check_gates_carry(offset, &carry);
            foreach(gate : affected_gates)
            {
                String a = this.gates[gate].wire;
                for(int i = (int)wrong_gates_queue.len() - 1; i>=0; i--)
                {
                    String b = this.gates[wrong_gates_queue[i]].wire;
                    this.set_inputs(inx, iny);
                    this.swap_gate_output(a,b);
                    if (this.run_and_compute_output() == expected)
                    {
                        Swap swap;
                        swap.a = gate;
                        swap.b = wrong_gates_queue[i];
                        if (!wrong_gates.contains(swap))
                        {
                            wrong_gates.push(swap);
                        }
                    }
                    this.swap_gate_output(b,a);
                }
            }

        }

        offset++;
    }

    // first try to reduce the complexity of the problem by swaping the output with others
    // and see if it fixes the issue

    if (verbose)
    {
        io::printfn("Left witfh %d pairs of gates to check", wrong_gates.len());
        io::printfn("Step 2 : Generate potential solutions containing 4 swaps.");
    }

    List(<Swap>) pairs = wrong_gates;

    List(<Swap[4]>) solutions;
    for(int i = 0; i < pairs.len(); i++)
    {
        if (verbose)
        {
            io::printfn("   - %d of %d", i+1, pairs.len());
        }

        Swap p1 = pairs[i];
        String p1a = this.gates[p1.a].wire;
        String p1b = this.gates[p1.b].wire;
        this.swap_gate_output(p1a, p1b);
        for (int j = i+1; j < pairs.len(); j++)
        {
            Swap p2 = pairs[j];
            String p2a = this.gates[p2.a].wire;
            String p2b = this.gates[p2.b].wire;
            if (p1.a == p2.a || p1.a == p2.b || p1.b == p2.a || p1.b == p2.b)
            {
                continue;
            }

            this.swap_gate_output(p2a, p2b);
            for (int k = j+1; k < pairs.len(); k++)
            {
                Swap p3 = pairs[k];
                String p3a = this.gates[p3.a].wire;
                String p3b = this.gates[p3.b].wire;
                if (p1.a == p3.a || p1.a == p3.b || p1.b == p3.a || p1.b == p3.b ||
                    p2.a == p3.a || p2.a == p3.b || p2.b == p3.a || p2.b == p3.b)
                {
                    continue;
                }

                this.swap_gate_output(p3a, p3b);
                for (int l = k+1; l < pairs.len(); l++)
                {
                    Swap p4 = pairs[l];
                    String p4a = this.gates[p4.a].wire;
                    String p4b = this.gates[p4.b].wire;
                    if (p1.a == p4.a || p1.a == p4.b || p1.b == p4.a || p1.b == p4.b ||
                        p2.a == p4.a || p2.a == p4.b || p2.b == p4.a || p2.b == p4.b ||
                        p3.a == p4.a || p3.a == p4.b || p3.b == p4.a || p3.b == p4.b )
                    {
                        continue;
                    }
                    this.swap_gate_output(p4a,p4b);

                    uint offst = 0;
                    bool all_good = true;
                    while (offst < 44)
                    {
                        ulong inx = ((ulong)1 << offst);
                        ulong iny = inx;
                        ulong expected = inx + iny;
                        this.set_inputs(inx, iny);

                        if(this.run_and_compute_output() != expected)
                        {
                            all_good = false;
                            break;
                        }

                        offst++;
                    }

                    if (all_good)
                    {
                        Swap[4] sol = {p1, p2, p3, p4};
                        solutions.push(sol);
                    }

                    this.swap_gate_output(p4b,p4a);
                }
                this.swap_gate_output(p3b,p3a);
            }
            this.swap_gate_output(p2a, p2b);
        }
        this.swap_gate_output(p1a, p1b);
    }

    if (verbose)
    {
        io::printfn("Left with potential %d solutions.", solutions.len());
        io::printfn("Step 3 : Going through all solutions and testinf or simple inputs.");
    }

    uint eliminated = 0;
    for(int i = (int) solutions.len()-1; i >= 0; i--)
    {
        Swap[4] sol = solutions[i];
        String a = this.gates[sol[0].a].wire;
        String b = this.gates[sol[0].b].wire;
        String c = this.gates[sol[1].a].wire;
        String d = this.gates[sol[1].b].wire;
        String e = this.gates[sol[2].a].wire;
        String f = this.gates[sol[2].b].wire;
        String g = this.gates[sol[3].a].wire;
        String h = this.gates[sol[3].b].wire;
        this.swap_gate_output(a, b);
        this.swap_gate_output(c, d);
        this.swap_gate_output(e, f);
        this.swap_gate_output(g, h);

        uint offst = 0;
        bool all_good = true;
        while (offst < 44)
        {
            ulong inx = ((ulong)1 << offst);
            ulong iny = 0;
            ulong expected = inx + iny;
            this.set_inputs(inx, iny);

            if(this.run_and_compute_output() != expected)
            {
                all_good = false;
                break;
            }

            offst++;
        }

        if (!all_good)
        {
            if (verbose)
            {
                io::printfn("   - Bad solution eliminated %d", ++eliminated);
            }

            solutions.remove_at(i);
        } 

        this.swap_gate_output(a, b);
        this.swap_gate_output(c, d);
        this.swap_gate_output(e, f);
        this.swap_gate_output(g, h);
    }

    if (verbose)
    {
        io::printfn("Left with potential %d solutions.", solutions.len());
        io::printfn("Step 4 : Using random inputs to force the wrong solutions left out.");
    }

    SimpleRandom rand;
    uint random_count = 0;
    while(++random_count)
    {
        ulong inx = (rand.next_long() << 20) >> 20;
        ulong iny = (rand.next_long() << 20) >> 20;
        ulong expected = inx + iny;

        for BIG: (int i = (int) solutions.len()-1; i >= 0; i--)
        {
            Swap[4] sol = solutions[i];
            String a = this.gates[sol[0].a].wire;
            String b = this.gates[sol[0].b].wire;
            String c = this.gates[sol[1].a].wire;
            String d = this.gates[sol[1].b].wire;
            String e = this.gates[sol[2].a].wire;
            String f = this.gates[sol[2].b].wire;
            String g = this.gates[sol[3].a].wire;
            String h = this.gates[sol[3].b].wire;
            this.swap_gate_output(a, b);
            this.swap_gate_output(c, d);
            this.swap_gate_output(e, f);
            this.swap_gate_output(g, h);

            this.set_inputs(inx, iny);
            ulong result = this.run_and_compute_output();

            this.swap_gate_output(g, h);
            this.swap_gate_output(e, f);
            this.swap_gate_output(c, d);
            this.swap_gate_output(a, b);

            if(result != expected)
            {
                if (verbose)
                {
                    io::printfn("   - Bad solution eliminated.");
                }

                solutions.remove_at(i);
            }
        }

        if (solutions.len() == 1)
        {
            break;
        }  
    }

    assert(solutions.len() == 1);
    String a = this.gates[solutions[0][0].a].wire;
    String b = this.gates[solutions[0][0].b].wire;
    String c = this.gates[solutions[0][1].a].wire;
    String d = this.gates[solutions[0][1].b].wire;
    String e = this.gates[solutions[0][2].a].wire;
    String f = this.gates[solutions[0][2].b].wire;
    String g = this.gates[solutions[0][3].a].wire;
    String h = this.gates[solutions[0][3].b].wire;

    String[8] result = {a, b, c, d, e, f, g, h};
    String[8] res = sort_output(result);

    if (verbose)
    {
        io::printfn("Step 5 : sorting the result.");
    }

    io::printf("Result is : ");
    foreach(iii, r : res)
    {
        if (iii != 0)
        {
            io::print(",");
        }

        io::print(r);
    }

    io::printn("");
}

fn void process(String data, bool is_part_b, bool verbose)
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
        circuit.find_issues(verbose);
    }
}