import std::io;

fn ulong blink(String number, uint count)
{
    bool even_digit_count = number.len % 2 == 0;

    if (count == 0)
    {
        return 1;
    }

    if (number == "0")
    {
        return blink("1", count-1);
    }

    if (even_digit_count)
    {
        uint size = number.len / 2;
        String second = number[size..number.len-1];
        while(second.len > 1 && second[0] == '0')
        {
            second = second[1..second.len-1];
        }

        return blink(number[0..size-1], count-1) + blink(second, count - 1);
    }

    ulong! val = number.to_ulong();
    if (catch err = val)
    {
        io::printfn("There was an error.");
        return 0;
    }

    char[40] buf;
    String! slice = (String) io::bprintf(&buf, "%d", val * 2024);
    if (catch err = slice)
    {
        io::printfn("There was an error.");
        return 0;
    }

    return blink(slice, count-1);
}

fn void process(String data, bool is_part_b)
{
    String[] numbers = data.split(" ");
	defer free(numbers);

    ulong total = 0;
    for(int i = 0; i < numbers.len; i++)
    {
        io::printfn("Step %d of %d", i+1, numbers.len);
        total += blink(numbers[i], 25);
    }

    io::printfn("Total is %d", total);
}