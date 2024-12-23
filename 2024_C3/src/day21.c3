import std::io;
import std::collections::list;
import std::collections::map;

// Pad0
//789
//456
//123
// 0A

// Pad1
// ^A
//<v>

def CharList = List(<char>);

struct Vector2
{
    int x;
    int y;
}

fn ulong to_value(String data)
{
    String inner = data[..data.len-2];
    ulong! out = inner.to_ulong();
    if (catch err = out)
    {
        return 0;
    }

    return out;
}

fn Vector2 to_position_small(char c)
{
    Vector2 out;

    switch(c)
    {
        case 'A':
        {
            out.y = 0;
            out.x = 2;
        }
        case '^':
        {
            out.y = 0;
            out.x = 1;
        }
        case '<':
        {
            out.y = 1;
            out.x = 0;
        }
        case 'v':
        {
            out.y = 1;
            out.x = 1;
        }
        case '>':
        {
            out.y = 1;
            out.x = 2;
        }
    }

    return out;
}

fn bool is_authorized_small(Vector2 a)
{
    return a.x != 0 || a.y != 0;
}

fn bool is_authorized_big(Vector2 a)
{
    return a.x != 0 || a.y != 3;
}

fn bool is_authorized(Vector2 a, bool default_grid)
{
    if (default_grid)
    {
        return is_authorized_big(a);
    }
    return is_authorized_small(a);
}

fn Vector2 to_position(char c)
{
    Vector2 out;

    switch(c)
    {
        case 'A':
        {
            out.y = 3;
            out.x = 2;
        }
        case '0':
        {
            out.y = 3;
            out.x = 1;
        }
        case '1':
        {
            out.y = 2;
            out.x = 0;
        }
        case '2':
        {
            out.y = 2;
            out.x = 1;
        }
        case '3':
        {
            out.y = 2;
            out.x = 2;
        }
        case '4':
        {
            out.y = 1;
            out.x = 0;
        }
        case '5':
        {
            out.y = 1;
            out.x = 1;
        }
        case '6':
        {
            out.y = 1;
            out.x = 2;
        }
        case '7':
        {
            out.y = 0;
            out.x = 0;
        }
        case '8':
        {
            out.y = 0;
            out.x = 1;
        }
        case '9':
        {
            out.y = 0;
            out.x = 2;
        }
    }

    return out;
}

fn void append_horizontal(int count, List(<char>)* out)
{
    if (count > 0)
    {
        for(int i = 0; i < count; i++)
        {
            out.push('>');
        }
    }
    else
    {
        for(int i = 0; i < (-count); i++)
        {
            out.push('<');
        }
    }

    out.push('A');
}

fn void append_vertical(int count, List(<char>)* out)
{
    if (count > 0)
    {
        for(int i = 0; i < count; i++)
        {
            out.push('v');
        }
    }
    else
    {
        for(int i = 0; i < (-count); i++)
        {
            out.push('^');
        }
    }

    out.push('A');
}

fn List(<CharList>) shortest_path_vec(Vector2 from, Vector2 to, bool default_grid)
{
    List(<CharList>) out;

    if (from.x == to.x && from.y == to.y)
    {
        CharList new_list;
        new_list.push('A');
        out.push(new_list);
        return out;
    }

    if (from.x == to.x)
    {
        List(<char>) new_list;
        append_vertical(to.y - from.y, &new_list);
        out.push(new_list);
        return out;
    }

    if (from.y == to.y)
    {
        List(<char>) new_list;
        append_horizontal(to.x - from.x, &new_list);
        out.push(new_list);
        return out;
    }

    int x_off = to.x - from.x;
    int y_off = to.y - from.y;

    if (x_off != 0)
    {
        Vector2 new_from = from;
        char c;

        if (x_off > 0)
        {
            new_from.x++;
            c = '>';
        }
        else
        {
            new_from.x--;
            c = '<';
        }

        if (is_authorized(new_from, default_grid))
        {
            List(<CharList>) subpaths = shortest_path_vec(new_from, to, default_grid);
            foreach(subpath : subpaths)
            {
                List(<char>) new_list;
                new_list.push(c);
                new_list.add_all(&subpath);
                out.push(new_list);
            }
        }
    }

    if (y_off != 0)
    {
        Vector2 new_from = from;
        char c;

        if (y_off > 0)
        {
            new_from.y++;
            c = 'v';
        }
        else
        {
            new_from.y--;
            c = '^';
        }

        if (is_authorized(new_from, default_grid))
        {
            List(<CharList>) subpaths = shortest_path_vec(new_from, to, default_grid);
            foreach(subpath : subpaths)
            {
                List(<char>) new_list;
                new_list.push(c);
                new_list.add_all(&subpath);
                out.push(new_list);
            }
        }
    }

    return out;
}

fn List(<CharList>) shortest_paths(char from, char to, bool default_grid)
{
    Vector2 from_pos;
    Vector2 to_pos;

    if (default_grid)
    {
        from_pos = to_position(from);
        to_pos = to_position(to);
    }
    else
    {
        from_pos = to_position_small(from);
        to_pos = to_position_small(to);
    }

    return shortest_path_vec(from_pos, to_pos, default_grid);
}

fn ulong compute_cost(char from, char to, char layer, bool default_grid)
{
    List(<CharList>) paths = shortest_paths(from, to, default_grid);
    ulong cost = ulong.max;

    if (layer == 0)
    {
        foreach(path : paths)
        {
            if (path.len() < cost)
            {
                cost = path.len();
            }
        }
        return cost;
    }

    foreach(path : paths)
    {
        ulong current_cost = compute_cost_chain((String) path.to_tarray(), layer-1, false);
        if (current_cost < cost)
        {
            cost = current_cost;
        }
    }

    return cost;
}

fn ulong compute_cost_chain(String chain, char layer, bool default_grid)
{
    ulong cost = 0;
    for(int i = 0; i < chain.len; i++)
    {
        char from = i > 0 ? chain[i-1] : 'A';
        char to = chain[i];
        cost += compute_cost(from, to, layer, default_grid);
    }

    return cost;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    ulong total = 0;
    foreach(String line : lines)
    {
        io::printfn("Doing step %s", line);
        if (line == "")
        {
            break;
        }

        ulong value = to_value(line);
        ulong shortest = compute_cost_chain(line, 9, true);

        io::printfn("Current step %s %s", shortest, value);
        total+=shortest*value;
    }

    io::printfn("Total is %d", total);
}