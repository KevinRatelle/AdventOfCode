import std::io;
import std::collections::list;
import std::sort;


struct Vector2
{
    int x;
    int y;
}

fn void print_grid(List(<String>)* image)
{
    for(int i = 0; i < image.len(); i++)
    {
        String str = image.get(i);
        io::printfn(str);
    }
}

fn Vector2 get_cursor(List(<String>)* map)
{
    Vector2 pos;
    pos.x = 0;
    pos.y = 0;

    foreach(int i, String str : map)
    {
        foreach(int j, char c : str)
        {
            if (map.get(i)[j] == '@')
            {
                pos.x = j;
                pos.y = i;
                return pos;
            }
        }
    }

    return pos;
}

fn Vector2 get_direction(char command)
{
    Vector2 dir;
    dir.x = 0;
    dir.y = 0;

    switch(command)
    {
        case '^':
        {
            dir.y = -1;
        }
        case 'v':
        {
            dir.y = 1;
        }
        case '<':
        {
            dir.x = -1;
        }
        case '>':
        {
            dir.x = 1;
        }
    }

    return dir;
}

fn void execute_command(List(<String>)* map, char command)
{
    Vector2 pos = get_cursor(map);
    Vector2 dir = get_direction(command);

    List(<Vector2>) list_to_check;
    List(<Vector2>) list_to_move;
    defer list_to_check.free();
    defer list_to_move.free();

    bool is_valid = true;

    list_to_check.push(pos);
    while(list_to_check.len() > 0)
    {
        Vector2! current = list_to_check.pop();
        if (catch err = current)
        {
            is_valid = false;
            break;
        }

        Vector2 next = current;
        next.x += dir.x;
        next.y += dir.y;

        char item = map.get(next.y)[next.x];
        if (item == '#')
        {
            is_valid = false;
            break;
        }

        list_to_move.push(current);

        if (item != '.')
        {
            list_to_check.push(next);
        }
    }

    if (is_valid)
    {
        if (dir.y > 0)
        {
            quicksort(list_to_move,  fn int (Vector2* a, Vector2* b) { return (a.y < b.y) ? 1 : -1; });
        }
        if (dir.y < 0)
        {
            quicksort(list_to_move,  fn int (Vector2* a, Vector2* b) { return (a.y > b.y) ? 1 : -1; });
        }
        if (dir.x > 0)
        {
            quicksort(list_to_move,  fn int (Vector2* a, Vector2* b) { return (a.x < b.x) ? 1 : -1; });
        }
        if (dir.x < 0)
        {
            quicksort(list_to_move,  fn int (Vector2* a, Vector2* b) { return (a.x > b.x) ? 1 : -1; });
        }

        foreach(Vector2 current : list_to_move)
        {
            Vector2 next = current;
            next.x += dir.x;
            next.y += dir.y;
            map.get(next.y)[next.x] = map.get(current.y)[current.x]; 
        }

        map.get(pos.y)[pos.x] = '.';
    }
}

fn ulong compute_gps(List(<String>)* map)
{
    ulong gps = 0;

    foreach(ulong i, String str : map)
    {
        foreach(ulong j, char c : str)
        {
            if (c == 'O')
            {
                gps += 100 * i + j;
            }
        }
    }

    return gps;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<String>) map;
    defer map.free();

    bool reading_map_mode = true;
    foreach(String line : lines)
    {
        if (line == "")
        {
            reading_map_mode = false;
        }

        if (reading_map_mode)
        {
            if (!is_part_b)
            {
                map.push(line);
            }
            else
            {
                String double_line = "";
                foreach(char c : line)
                {
                    switch (c)
                    {
                        case '.':
                        {
                            double_line = double_line.concat("..");
                        }
                        case '@':
                        {
                            double_line = double_line.concat("@.");
                        }
                        case '#':
                        {
                            double_line = double_line.concat("##");
                        }
                        case 'O':
                        {
                            double_line = double_line.concat("[]");
                        }
                    }        
                }

                map.push(double_line);
            }
        }
        else
        {
            foreach(char command : line)
            {
                //print_grid(&map);
                execute_command(&map, command);
            }
        }
    }

    ulong total = compute_gps(&map);
    io::printfn("Total is %d", total);
}