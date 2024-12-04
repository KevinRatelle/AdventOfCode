import std::io;

fn void process(String data, bool is_part_b)
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

    io::printfn("Total is %d", total);
}