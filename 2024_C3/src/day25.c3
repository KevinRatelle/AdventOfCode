import std::io;
import std::collections::list;

fn void process(String data, bool is_part_b)
{
    String[] groups = data.split("\r\n\r\n");
    defer free(groups);

    List(<uint[5]>) keys;
    List(<uint[5]>) locks;

    foreach(group : groups)
    {
        String[] lines = group.split("\r\n");
	    defer free(lines);
        assert(lines.len == 7);

        if (lines[0] == "#####")
        {
            uint[5] lock = {0, 0, 0, 0, 0};

            for (int i = 1; i < 7; i++)
            {
                String line = lines[i];
                assert(line.len == 5);

                for (int j = 0; j < line.len; j++)
                {
                    if (line[j] == '#')
                    {
                        lock[j]++;
                    }
                }
            }

            locks.push(lock);
        }
        else
        {
            uint[5] key;

            for (int i = 5; i >= 0; i--)
            {
                String line = lines[i];
                assert(line.len == 5);

                for (int j = 0; j < line.len; j++)
                {
                    if (line[j] == '#')
                    {
                        key[j]++;
                    }
                }
            }

            keys.push(key);
        }
    }

    uint out = 0;
    foreach(key : keys)
    {
        foreach(lock : locks)
        {
            bool fit = true;
            for(int i = 0; i < 5; i++)
            {
                if ((lock[i] + key[i]) > 5)
                {
                    fit = false;
                    break;
                }
            }

            if (fit)
            {
                out++;
            }
        }
    }

    io::printfn("Got %d matching pairs", out);
}