import std::io;
import std::collections::list;

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

    Vector2 cursor = pos;
    while(true)
    {
        cursor.x += dir.x;
        cursor.y += dir.y;

        char item = map.get(cursor.y)[cursor.x];
        if (item == '#')
        {
            break;
        }

        if (item == '.')
        {
            dir.x = -dir.x;
            dir.y = -dir.y;

            while(cursor.x != pos.x || cursor.y != pos.y)
            {
                Vector2 next = cursor;
                next.x += dir.x;
                next.y += dir.y;
                map.get(cursor.y)[cursor.x] = map.get(next.y)[next.x];
                cursor = next;
            }

            map.get(pos.y)[pos.x] = '.';
            break;
        }
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
            map.push(line);
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