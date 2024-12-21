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

fn int cheapest_path(String[] grid)
{
    Cost goal;
    goal.pos = get_pos(grid, 'E');

    Cost start;
    start.pos = get_pos(grid, 'S');
    start.g = 0;
    start.h = heuristic(start, goal);
    start.f = start.g + start.h;

    List(<Cost>) closed_list;
    defer closed_list.free();

    List(<Cost>) open_list;
    defer open_list.free();

    open_list.push(start);

    int best = 1000;

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
        }

        closed_list.push(current);
        if (goal.pos.equals(current.pos))
        {
            best = current.g;
            break;
        }

        if (current.pos.x + 1 < grid[0].len)
        {
            Cost neighbor = current;
            neighbor.pos.x += 1;
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
            if (grid[neighbor.pos.y][neighbor.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }

        if (open_list.len() == 0)
        {
            best = -1;
        }
    }

    return best;
} 

fn List(<Vector2>) get_wall_list(String[] input)
{
    List(<Vector2>) walls;

    for(int i = 1; i < input.len-1; i++)
    {
        for(int j = 1; j < input[0].len-1; j++)
        {
            char item = input[i][j];
            if (item != '#')
            {
                continue;
            }

            if (input[i+1][j] != '#' && input[i-1][j] != '#' ||
                input[i][j+1] != '#' && input[i][j-1] != '#')
            {
                Vector2 pos;
                pos.x = j;
                pos.y = i;
                walls.push(pos);
            }
        }
    }

    return walls;
}

fn void process(String data, bool is_part_b)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    ulong cost = cheapest_path(grid);

    ulong total_save = 0;

    List(<Vector2>) wall_list = get_wall_list(grid);
    foreach(uint i, Vector2 wall : wall_list)
    {
        io::printfn("Testing %d of %d", i, wall_list.len());
        grid[wall.y][wall.x] = '.';
        int new_cost = cheapest_path(grid);
        grid[wall.y][wall.x] = '#';
        
        ulong saved = cost - new_cost;
        if (saved >= 100)
        {
            total_save++;
        }
    }

    io::printfn("Total save is %d", total_save);
}