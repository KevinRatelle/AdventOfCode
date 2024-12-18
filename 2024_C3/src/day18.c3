import std::io;
import std::collections::list;

struct Vector2
{
    int x;
    int y;
}

struct Cost
{
    Vector2 pos;
    uint g;
    uint h;
    uint f;
}

fn bool Vector2.equals(Vector2* this, Vector2 other)
{
    return this.x == other.x && this.y == other.y;
}

fn bool Cost.equals(Cost* this, Cost other)
{
    return this.pos.equals(other.pos);
}

fn void Cost.compute_f(Cost* this)
{
    this.f = this.g + this.h;
}

fn void Cost.set_g(Cost* this, uint g)
{
    this.g = g;
}

fn void Cost.set_h(Cost* this, uint h)
{
    this.h = h;
}

fn uint heuristic(Cost start, Cost goal)
{
    return $$abs(goal.pos.x - start.pos.x) + $$abs(goal.pos.y - start.pos.y);
}

fn int get_smallest(List(<Cost>)* list)
{
    uint smallest = list.get(0).f;

    int index = 0;
    for(int i = 1; i < list.len(); i++)
    {
        if (list.get(i).f < smallest)
        {
            smallest = list.get(i).f;
            index = i;
        }
    }

    return index;
}

fn int index_of(List(<Cost>)* list, Cost item)
{
    foreach(int i, Cost cost : list)
    {
        if (cost.equals(item))
        {
            return i;
        }
    }

    return -1;
}

fn bool contains(List(<Cost>)* list, Cost item)
{
    return index_of(list, item) != -1;
}

fn void update_open_list(List(<Cost>)* open_list, Cost item, Cost goal, uint tentative_g)
{
    int idx = index_of(open_list, item);
    if (idx == -1)
    {
        item.g = tentative_g;
        item.h = heuristic(item, goal);
        item.f = item.g + item.h;
        open_list.push(item);
    }
    else if (tentative_g < open_list.get(idx).g)
    {
        open_list.get(idx).set_g(tentative_g);
        open_list.get(idx).set_h(heuristic(open_list.get(idx), goal));
        open_list.get(idx).compute_f();
    }
}

fn uint cheapest_path(List(<String>)* grid, bool is_part_b)
{
    Cost goal;
    goal.pos.y = (int) grid.len() - 1;
    goal.pos.x = (int) grid[0].len() - 1;

    Cost start;
    start.pos.x = 0;
    start.pos.y = 0;
    start.g = 0;
    start.h = heuristic(start, goal);
    start.f = start.g + start.h;

    List(<Cost>) closed_list;
    defer closed_list.free();

    List(<Cost>) open_list;
    defer open_list.free();

    open_list.push(start);

    uint best = 1000;

    while(open_list.len() > 0)
    {
        int smallest_index = get_smallest(&open_list);

        open_list.swap(open_list.len() - 1, smallest_index);
        Cost! current = open_list.pop();
        if (catch err = current)
        {
            break;
        }

        if (heuristic(current, goal) < best)
        {
            best = heuristic(current, goal);
            io::printfn("Current best : %d", best);
        }

        closed_list.push(current);
        if (goal.pos.equals(current.pos))
        {
            best = current.g;
            break;
        }

        if (current.pos.x + 1 < grid[0].len())
        {
            Cost neighbor = current;
            neighbor.pos.x += 1;
            if (grid.get(neighbor.pos.y)[neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.x - 1 >= 0)
        {
            Cost neighbor = current;
            neighbor.pos.x -= 1;
            if (grid.get(neighbor.pos.y)[neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.y + 1 < grid.len())
        {
            Cost neighbor = current;
            neighbor.pos.y += 1;
            if (grid.get(neighbor.pos.y)[neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.y - 1 >= 0)
        {
            Cost neighbor = current;
            neighbor.pos.y -= 1;
            if (grid.get(neighbor.pos.y)[neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
    }

    return best;
} 

fn void process(String data, bool is_part_b)
{
    uint grid_size = 71;
    uint byte_to_read = 1024;

    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<String>) grid;
    defer grid.free();
    for(int i = 0; i < grid_size; i++)
    {
        String row;
        for(int j= 0; j < grid_size; j++)
        {
            row = row.concat(".");
        }
        grid.push(row);
    }
    
    uint count = 0;
    foreach(String line : lines)
    {
        String[] split = line.split(",");
        defer free(split);

        uint! x = split[0].to_uint();
        if (catch err = x)
        {
            break;
        }

        uint! y = split[1].to_uint();
        if (catch err = y)
        {
            break;
        }

        grid.get(y)[x] = '#';
        count++;
        if (count == byte_to_read)
        {
            break;
        }
    }

    foreach(String row : grid)
    {
        io::printn(row);
    }

    uint cost = cheapest_path(&grid, is_part_b);
    io::printfn("Total is %d", cost);
}