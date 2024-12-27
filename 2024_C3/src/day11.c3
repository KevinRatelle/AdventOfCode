import std::io;
import std::collections::map;

struct Key
{
    String name;
    uint layer;
}

fn uint Key.hash(Key* this)
{
    return this.name.hash() + this.layer;
}

fn bool Key.equals(Key* this, Key key)
{
    return this.name == key.name && this.layer == key.layer;
}

fn ulong blink(String number, uint count, Map(<Key,ulong>)* map)
{
    bool even_digit_count = number.len % 2 == 0;

    Key key;
    key.name = number;
    key.layer = count;
    if (map.has_key(key))
    {
        ulong! res = map.get(key);
        if (catch err = res)
        {
            io::printfn("Error");
            return 0;
        }
        return res;
    }

    if (count == 0)
    {
        return 1;
    }

    if (number == "0")
    {
        return blink("1", count-1, map);
    }

    if (even_digit_count)
    {
        uint size = number.len / 2;
        String second = number[size..number.len-1];
        while(second.len > 1 && second[0] == '0')
        {
            second = second[1..second.len-1];
        }

        ulong res = blink(number[0..size-1], count-1, map) + blink(second, count - 1, map);
        map.set(key, res);
        return res;
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

    ulong res = blink(slice, count-1, map);
    map.set(key, res);
    return res;
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] numbers = data.split(" ");
	defer free(numbers);

    Map(<Key,ulong>) result_map;

    ulong total = 0;
    for(int i = 0; i < numbers.len; i++)
    {
        if (verbose)
        {
            io::printfn("Step %d of %d", i+1, numbers.len);
        }

        total += blink(numbers[i], is_part_b ? 75 : 25, &result_map);
    }

    io::printfn("Total is %d", total);
}