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
    int from;
}

fn bool Vector2.equals(Vector2* this, Vector2 other)
{
    return this.x == other.x && this.y == other.y;
}

fn Vector2 Vector2.minus(Vector2* this, Vector2 other)
{
    Vector2 out;
    out.x = this.x - other.x;
    out.y = this.y - other.y;
    return out;
}

fn uint Vector2.length(Vector2* this)
{
    return $$abs(this.x) + $$abs(this.y);
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

fn Vector2 get_pos(String[] grid, char to_find)
{
    Vector2 pos;
    pos.x = -1;
    pos.y = -1;

    foreach(int i, String str : grid)
    {
        foreach (int j, char c : str)
        {
            if (to_find == c)
            {
                pos.x = j;
                pos.y = i;
                return pos;
            }
        }
    }

    return pos;
}

fn List(<Vector2>) construct_path(List(<Cost>) closed_list)
{
    List(<Vector2>) path;

    Cost! item = closed_list.pop();
    if (catch err = item)
    {
        return path;
    }

    path.push(item.pos);

    while(item.from != -1)
    {
        item = closed_list[item.from];
        path.push(item.pos);
    }

    return path;
}

fn List(<Vector2>) cheapest_path(String[] grid)
{
    Cost goal;
    goal.pos = get_pos(grid, 'E');

    Cost start;
    start.pos = get_pos(grid, 'S');
    start.g = 0;
    start.h = heuristic(start, goal);
    start.f = start.g + start.h;
    start.from = -1;

    List(<Cost>) closed_list;
    defer closed_list.free();

    List(<Cost>) open_list;
    defer open_list.free();

    open_list.push(start);

    while(open_list.len() > 0)
    {
        int smallest_index = get_smallest(&open_list);

        open_list.swap(open_list.len() - 1, smallest_index);
        Cost! current = open_list.pop();
        if (catch err = current)
        {
            break;
        }

        closed_list.push(current);
        if (goal.pos.equals(current.pos))
        {
            break;
        }

        if (current.pos.x + 1 < grid[0].len)
        {
            Cost neighbor = current;
            neighbor.pos.x += 1;
            neighbor.from = (int) closed_list.len() - 1;
            if (grid[neighbor.pos.y][neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.x - 1 >= 0)
        {
            Cost neighbor = current;
            neighbor.pos.x -= 1;
            neighbor.from = (int) closed_list.len() - 1;
            if (grid[neighbor.pos.y][neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.y + 1 < grid.len)
        {
            Cost neighbor = current;
            neighbor.pos.y += 1;
            neighbor.from = (int) closed_list.len() - 1;
            if (grid[neighbor.pos.y][neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        if (current.pos.y - 1 >= 0)
        {
            Cost neighbor = current;
            neighbor.pos.y -= 1;
            neighbor.from = (int) closed_list.len() - 1;
            if (grid[neighbor.pos.y][neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
    }

    return construct_path(closed_list);
} 

fn void process(String data, bool is_part_b, bool dummy)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    List(<Vector2>) path = cheapest_path(grid);
    defer path.free();

    uint k_max_jump = is_part_b ? 20 : 2;

    uint count = 0;
    for(int i = 0; i < path.len(); i++)
    {
        Vector2 a = path[i];
        for(int j = i+1; j < path.len(); j++)
        {
            Vector2 b = path[j];
            Vector2 diff = a.minus(b);
            uint saved = j - i - diff.length();
            if (diff.length() <= k_max_jump && saved >= 100)
            {
                count++;
            }               
        }
    }

    io::printfn("Path count is %d", count);
}