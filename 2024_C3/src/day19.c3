import std::io;
import std::collections::list;

struct StringWeight
{
    String s;
    ulong w;
}

fn bool StringWeight.equals(StringWeight* this, StringWeight other)
{
    return this.s == other.s;
}

fn List(<String>) read_dictionary(String line)
{
    List(<String>) dictionary;

    String[] dict = line.split(", ");
    foreach(String element : dict)
    {
        dictionary.push(element);
    }

    return dictionary;
}

fn ulong pattern_count(String pattern, List(<String>)* dictionary, List(<StringWeight>)* precomputed)
{
    ulong count = 0;

    foreach(StringWeight item : precomputed)
    {
        if (item.s == pattern)
        {
            return item.w;
        }
    }

    for( int i  = 0; i < dictionary.len(); i++)
    {
        String item = dictionary.get(i);
        if (pattern.starts_with(item))
        {
            if (item.len == pattern.len)
            {
                count++;
                break;
            }

            String sub = pattern[item.len..pattern.len-1];
            count += pattern_count(sub, dictionary, precomputed);
        }
    }

    StringWeight new;
    new.s = pattern;
    new.w = count;
    for(int i = 0; i < precomputed.len(); i++)
    {
        if (precomputed.get(i).w < new.w)
        {
            precomputed.insert_at(i, new);
            return count;
        }
    }

    precomputed.push(new);

    return count;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<String>) dictionary = read_dictionary(lines[0]);
    defer dictionary.free();

    List(<StringWeight>) precomputed;
    defer precomputed.free();

    ulong possible_count = 0;
    ulong total_count = 0;
    for(int i = 2; i<lines.len; i++)
    {
        io::printfn("Current step %d", i-1);
        String pattern = lines[i];


        ulong count = pattern_count(pattern, &dictionary, &precomputed);
        if (count > 0)
        {
            total_count += count;
            possible_count++;
        }
    }

    io::printfn("Possible count = %d %d", possible_count, total_count);
}