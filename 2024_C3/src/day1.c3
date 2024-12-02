
import std::io;
import std::collections;
import std::sort;

fault ComputationFailed
{
    ARRAYS_NOT_SAME_LENGTH
}

fn uint! compute_total(List(<int>) a, List(<int>) b)
{
    quicksort(a);
    quicksort(b);

    if (a.len() != b.len())
    {
        return ComputationFailed.ARRAYS_NOT_SAME_LENGTH?;
    }

    uint sum = 0;
    for (uint i = 0; i < a.len(); i++)
    {
        uint diff = $$abs(a[i] - b[i]);
        sum += diff;
    }

    return sum;
}

fn void process(String[] lines)
{
    List(<int>) first_array;
    List(<int>) second_array;

    for (int i = 0; i < lines.len; i++)
    {
        io::printn(lines[i]);

        String[] values = lines[i].split("   ");
        if (values.len < 2)
        {
            break;
        }

        int! a = values[0].to_int();
        int! b = values[1].to_int();

        if (catch err = a)
        {
            return;
        }

        if (catch err = b)
        {
            return;
        }

        first_array.push(a);
        second_array.push(b);
    }

    uint! total = compute_total(first_array, second_array);
    if (catch err = total)
    {
        return;
    }
    io::printfn("Total is %d", total);
}