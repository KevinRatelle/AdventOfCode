import std::io;
import std::collections::list;

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

fn bool is_possible_pattern(String pattern, List(<String>)* dictionary)
{
    foreach(String item : dictionary)
    {
        if (pattern.starts_with(item))
        {
            if (item.len == pattern.len)
            {
                return true;
            }

            String sub = pattern[item.len..pattern.len-1];
            bool is_possible = is_possible_pattern(sub, dictionary);
            if (is_possible)
            {
                return true;
            }
        }
    }

    return false;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<String>) dictionary = read_dictionary(lines[0]);

    uint possible_count = 0;
    for(int i = 2; i<lines.len; i++)
    {
        String pattern = lines[i];

        if (is_possible_pattern(pattern, &dictionary))
        {
            possible_count++;
        }
    }

    io::printfn("Possible count = %d", possible_count);
}