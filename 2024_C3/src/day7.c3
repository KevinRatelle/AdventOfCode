
import std::io;
import std::collections::list;

fn ulong concatenate(ulong a, ulong b)
{
    char[40] buf;
    
    String! slice = (String) io::bprintf(&buf, "%d%d", a, b);
    if (catch err = slice)
    {
        io::printn("Error printing both longs into the same buffer.");
        return 0;
    }

    ulong! result = slice.to_ulong();
    if (catch err = result)
    {
        io::printn("Error converting concatenation to ulong.");
        return 0;
    }

    return result;
}

fn bool solve(List(<ulong>) values, ulong total, ulong current_total, uint index, bool allow_concat)
{
    // Brute force is an option. The number of combinations is 2^(N-1).
    // So for 12 items, it's 2^11 = 2048, which is still fine
    // To optimize, start with the multiplication and early out when we go over total.

    ulong value = values[index];
    if (index == (values.len() - 1))
    {
        return ((value * current_total) == total) ||
               ((value + current_total) == total) ||
               (allow_concat && (concatenate(current_total, value) == total));
    }

    uint next_index = index + 1;
    bool mult = false;
    bool add = false;
    bool concat = false;
    if ((value * current_total) <= total)
    {
        mult = solve(values, total, value * current_total, next_index, allow_concat);
    }
    if ((value + current_total) <= total)
    {
        add = solve(values, total, value + current_total, next_index, allow_concat);
    }
    if (allow_concat)
    {
        ulong concat_val = concatenate(current_total, value);
        if (concat_val <= total)
        {
            concat = solve(values, total, concat_val, next_index, allow_concat);
        }
    }

    return add || mult || concat;
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    ulong total = 0;
    uint i = 1;

    foreach(String line : lines)
    {
        if (verbose)
        {
            io::printfn("Step %d / %d", i++, lines.len);
        }

        String[] equation = line.split(": ");
        defer free(equation);

        if (equation.len != 2)
        {
            io::printn("Error, not to items.");
            continue;
        }

        ulong! result = equation[0].to_ulong();
        if (catch err = result)
        {
            io::printn("Error casting to ulong.");
            continue;
        }

        String[] items = equation[1].split(" ");
        defer free(items);

        List(<ulong>) values;
        values.new_init();

        foreach (String item : items)
        {
            ulong! val = item.to_ulong();
            if (catch err = val)
            {
                io::printn("Error casting to ulong.");
                break;
            }

            values.push(val);
        }

        if (solve(values, result, values[0], 1, is_part_b))
        {
            total += result;
        }

        values.free();
    }

    io::printfn("Total is %d", total);
}