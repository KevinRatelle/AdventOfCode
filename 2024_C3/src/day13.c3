import std::io;
import std::collections::list;
import std::sort;

struct Position
{
    ulong x;
    ulong y;
}

struct Machine
{
    Position a;
    Position b;
    Position prize;
}

fn Position read_position(String line)
{
    String[] temp = line.split(": ");
    defer free(temp);

    String data = temp[1];

    String[] position_string = data.split(", ");
    defer free(position_string);
    
    String x_string = position_string[0];
    String y_string = position_string[1];

    String needle = "+";
    if (!x_string.contains("+"))
    {
        needle = "=";
    }
    String[] x_temp = x_string.split(needle);
    defer free(x_temp);
    String[] y_temp = y_string.split(needle);
    defer free(y_temp);

    String x_str = x_temp[1];
    String y_str = y_temp[1];

    ulong! x = x_str.to_ulong();
    ulong! y = y_str.to_ulong();

    Position pos;
    if (catch err = x)
    {
        return pos;
    }

    if (catch err = y)
    {
        return pos;
    }

    pos.x = x;
    pos.y = y;

    return pos;
}

fn ulong cheapest_path(Machine machine)
{
    // Linear algebra, 2 equations 2 variables, only 1 solution
    // M * ax + N * bx = cx
    // M * ay + N * by = cy

    // Equation for M
    // M = (cy - N * by) / ay

    // Find equation for N
    // (cy - N * by) / ay * ax + N * bx = cx
    // (cy - N * by) ax + N * bx * ay = cx * ay
    // cy * ax + N (bx * ay - by * ax) = cx * ay
    // N (bx * ay - by * ax) = cx * ay - cy * ax
    // N = (cx * ay - cy * ax) / (bx * ay - by * ax)

    long cx = machine.prize.x;
    long cy = machine.prize.y;

    long ay = machine.a.y;
    long ax = machine.a.x;

    long by = machine.b.y;
    long bx = machine.b.x;

    long button_b_numerator = cx * ay - cy * ax;
    long button_b_denom = bx * ay - by * ax;

    if (button_b_numerator % button_b_denom != 0)
    {
        // no solution for B button
        return 0;
    }

    ulong button_b_press_count = button_b_numerator / button_b_denom;

    ulong button_a_numerator = machine.prize.y - button_b_press_count * by;
    if (button_a_numerator % ay != 0)
    {
        // no solution for A button
        return 0;
    }

    ulong button_a_press_count = button_a_numerator / ay;
    return button_b_press_count + button_a_press_count*3;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<Machine>) machines;
    defer machines.free();
    for(int i = 0; i<lines.len; i+=4)
    {
        Machine machine;
        machine.a = read_position(lines[i]);
        machine.b = read_position(lines[i+1]);
        machine.prize = read_position(lines[i+2]);

        if (is_part_b)
        {
            machine.prize.x += 10000000000000;
            machine.prize.y += 10000000000000;
        }

        machines.push(machine);
    }

    ulong total = 0;
    for(int i = 0; i < machines.len(); i++)
    {
        Machine machine = machines[i];
        ulong path_cost = cheapest_path(machine);
        io::printfn("Path %d (of %d) costs %d", i, machines.len(), path_cost);

        total += path_cost;
    }

    io::printfn("Total is %d", total);
}