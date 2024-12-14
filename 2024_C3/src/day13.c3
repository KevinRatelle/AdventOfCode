import std::io;
import std::collections::list;
import std::sort;

struct Position
{
    uint x;
    uint y;
}

struct Machine
{
    Position a;
    Position b;
    Position prize;
}

struct PosCost
{
    uint x;
    uint y;
    uint g;
    uint h;
    uint f;
    uint total_a;
    uint total_b;
    PosCost* parent;
}

fn bool PosCost.equals(PosCost* this, PosCost pos)
{
    return (this.x == pos.x) && (this.y == pos.y);
}

fn Position read_position(String line)
{
    String[] temp = line.split(": ");
    defer free(temp);

    String data = temp[1];

    String[] position_string = data.split(", ");
    defer free(position_string);
    
    String x_string = position_string[0];
    String y_string = position_string[1];

    String needle = "+";
    if (!x_string.contains("+"))
    {
        needle = "=";
    }
    String[] x_temp = x_string.split(needle);
    defer free(x_temp);
    String[] y_temp = y_string.split(needle);
    defer free(y_temp);

    String x_str = x_temp[1];
    String y_str = y_temp[1];

    int! x = x_str.to_int();
    int! y = y_str.to_int();

    Position pos;
    if (catch err = x)
    {
        return pos;
    }

    if (catch err = y)
    {
        return pos;
    }

    pos.x = x;
    pos.y = y;

    return pos;
}

fn uint heuristic(PosCost start, PosCost goal)
{
    return goal.x - start.x + goal.y - start.y;
}

fn int get_smallest(List(<PosCost>)* list)
{
    uint smallest = list.get(0).f;
    int index = 0;
    for(int i = 0; i < list.len(); i++)
    {
        if (list.get(i).f < smallest)
        {
            smallest = list.get(i).f;
            index = i;
        }
    }

    return index;
}

fn bool is_button_a(Machine machine)
{
    return false;
}

fn uint path_cost(PosCost end)
{
    uint cost = 0;
    PosCost* parent = end.parent;
    PosCost current = end;
    while (parent.x != 0 || parent.y != 0)
    {
        cost += 1;

        current = *parent;
        parent = parent.parent;
    }

    return cost;
}

fn bool contains(List(<PosCost>)* list, PosCost item)
{
    foreach(PosCost pos : list)
    {
        if (pos.x == item.x && pos.y == item.y)
        {
            return true;
        }
    }

    return false;
}

fn int index_of(List(<PosCost>)* list, PosCost item)
{
    for(int i = 0; i < list.len(); i++)
    {
        if (list.get(i).x == item.x && list.get(i).y == item.y)
        {
            return i;
        }
    }

    return -1;
}

fn uint cheapest_path(Machine machine)
{
    PosCost goal;
    goal.x = machine.prize.x;
    goal.y = machine.prize.y;

    PosCost start;
    start.x = 0;
    start.y = 0;
    start.g = 0;
    start.total_a = 0;
    start.total_b = 0;
    start.h = heuristic(start, goal);
    start.f = start.g + start.h;

    List(<PosCost>) open_list;
    defer open_list.free();

    List(<PosCost>) closed_list;
    defer closed_list.free();

    open_list.push(start);

    while(open_list.len() > 0)
    {
        int smallest_index = get_smallest(&open_list);
        PosCost current = open_list[smallest_index];

        //io::printn(current);

        if (current.equals(goal))
        {
            return current.g;
        }

        closed_list.push(current);

        usz! index = open_list.index_of(current);
        if (catch err = index)
        {
            continue;
        }

        open_list.remove_at(index);

        PosCost neighbor_a = current;
        neighbor_a.x += machine.a.x;
        neighbor_a.y += machine.a.y;

        if (!contains(&closed_list, neighbor_a))
        {
            uint tentative_g = current.g + 3;
            
            int idx = index_of(&open_list, neighbor_a);
            if (idx == -1)
            {
                neighbor_a.parent = &current;
                neighbor_a.g = tentative_g;
                neighbor_a.h = heuristic(neighbor_a, goal);
                neighbor_a.f = neighbor_a.g + neighbor_a.h;
                neighbor_a.total_a++;

                if (neighbor_a.total_a <= 100)
                {
                    open_list.push(neighbor_a);
                }
            }
            else if (tentative_g < neighbor_a.g)
            {
                open_list[idx].parent = &current;
                open_list[idx].g = tentative_g;
                open_list[idx].h = heuristic(open_list[idx], goal);
                open_list[idx].f = open_list[idx].g + open_list[idx].h;
                open_list[idx].total_a++;
            }
        }

        PosCost neighbor_b = current;
        neighbor_b.x += machine.b.x;
        neighbor_b.y += machine.b.y;

        if (!contains(&closed_list, neighbor_b))
        {
            uint tentative_g = current.g + 1;
            
            int idx = index_of(&open_list, neighbor_b);
            if (idx == -1)
            {
                neighbor_b.parent = &current;
                neighbor_b.g = tentative_g;
                neighbor_b.h = heuristic(neighbor_b, goal);
                neighbor_b.f = neighbor_b.g + neighbor_b.h;
                neighbor_b.total_b++;

                if (neighbor_b.total_b <= 100)
                {
                    open_list.push(neighbor_b);
                }
            }
            else if (tentative_g < neighbor_b.g)
            {
                open_list[idx].parent = &current;
                open_list[idx].g = tentative_g;
                open_list[idx].h = heuristic(open_list[idx], goal);
                open_list[idx].f = open_list[idx].g + open_list[idx].h;
                open_list[idx].total_b++;
            }
        }
    }

    return 0;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<Machine>) machines;
    defer machines.free();
    for(int i = 0; i<lines.len; i+=4)
    {
        Machine machine;
        machine.a = read_position(lines[i]);
        machine.b = read_position(lines[i+1]);
        machine.prize = read_position(lines[i+2]);

        machines.push(machine);
    }

    ulong total = 0;
    for(int i = 0; i < machines.len(); i++)
    {
        Machine machine = machines[i];
        uint path_cost = cheapest_path(machine);
        io::printfn("Path %d (of %d) costs %d", i, machines.len(), path_cost);

        total += path_cost;
    }

    io::printfn("Total is %d", total);
}