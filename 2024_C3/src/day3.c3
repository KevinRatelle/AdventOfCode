import std::io;

fn usz compute_mul(String data)
{
    usz total = 0;

    String[] splits = data.split("mul(");
    foreach(split : splits)
    {
        String[] clean = split.split(")");
        if (clean.len < 1)
        {
            continue;
        }

        String[] numbers = clean[0].split(",");
        if (numbers.len != 2)
        {
            continue;
        }

        ulong! a = numbers[0].to_uint();
        if (catch error = a)
        {
            continue;
        }

        ulong! b = numbers[1].to_uint();
        if (catch error = b)
        {
            continue;
        }

        total += a * b;
    }

    return total;
}

fn void process(String data, bool is_part_b)
{
    usz total = 0;

    if (is_part_b)
    {
        String[] split = data.split("do()");
        foreach(data_chunk : split)
        {
            String[] data_pair = data_chunk.split("don't()");
            total += compute_mul(data_pair[0]);
        }
    }
    else
    {
        total = compute_mul(data);
    }

    io::printfn("Total is %d", total);
}