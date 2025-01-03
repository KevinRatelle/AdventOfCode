import std::io;
import std::collections::list;
import std::sort;

struct Vector2
{
    int x;
    int y;
}

struct Deer
{
    Vector2 pos;
    Vector2 dir;
}

struct Cost
{
    uint g;
    uint h;
    uint f;
}

struct DeerCost
{
    Deer deer;
    Cost cost;
    char op;
    uint from;
}

fn bool Vector2.equals(Vector2* this, Vector2 other)
{
    return this.x == other.x && this.y == other.y;
}

fn bool Deer.equals(Deer* this, Deer other)
{
    return this.pos.equals(other.pos) && this.dir.equals(other.dir);
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

fn bool DeerCost.equals(DeerCost* this, DeerCost other)
{
    return this.deer.equals(other.deer) && this.op == other.op;
}

fn uint heuristic(DeerCost start, DeerCost goal)
{
    return $$abs(goal.deer.pos.x - start.deer.pos.x) + $$abs(goal.deer.pos.y - start.deer.pos.y);
}

fn int get_smallest(List(<DeerCost>)* list)
{
    uint smallest = list.get(0).cost.f;

    int index = 0;
    for(int i = 1; i < list.len(); i++)
    {
        if (list.get(i).cost.f < smallest)
        {
            smallest = list.get(i).cost.f;
            index = i;
        }
    }

    return index;
}

fn int index_of(List(<DeerCost>)* list, DeerCost item)
{
    foreach(int i, DeerCost deer_cost : list)
    {
        if (deer_cost.equals(item))
        {
            return i;
        }
    }

    return -1;
}

fn bool contains(List(<DeerCost>)* list, DeerCost item)
{
    return index_of(list, item) != -1;
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

fn void update_open_list(List(<DeerCost>)* open_list, DeerCost item, DeerCost goal, uint tentative_g)
{
    int idx = index_of(open_list, item);
    if (idx == -1)
    {
        item.cost.g = tentative_g;
        item.cost.h = heuristic(item, goal);
        item.cost.f = item.cost.g + item.cost.h;
        open_list.push(item);
    }
    else if (tentative_g < open_list.get(idx).cost.g)
    {
        open_list.get(idx).cost.set_g(tentative_g);
        open_list.get(idx).cost.set_h(heuristic(open_list.get(idx), goal));
        open_list.get(idx).cost.compute_f();
    }
}

fn uint cheapest_path(String[] grid, bool is_part_b, bool verbose)
{
    DeerCost goal;
    goal.deer.pos = get_pos(grid, 'E');

    DeerCost start;
    start.deer.pos = get_pos(grid, 'S');
    start.deer.dir.x = 1;
    start.deer.dir.y = 0;
    start.cost.g = 0;
    start.cost.h = heuristic(start, goal);
    start.cost.f = start.cost.g + start.cost.h;

    List(<DeerCost>) closed_list;
    defer closed_list.free();

    List(<DeerCost>) open_list;
    defer open_list.free();

    open_list.push(start);

    uint best = 1000;

    while(open_list.len() > 0)
    {
        int smallest_index = get_smallest(&open_list);

        open_list.swap(open_list.len() - 1, smallest_index);
        DeerCost! current = open_list.pop();
        if (catch err = current)
        {
            break;
        }

        if (heuristic(current, goal) < best)
        {
            best = heuristic(current, goal);

            if (verbose)
            {
                io::printfn("Current best : %d", best);
            }
        }

        closed_list.push(current);
        if (goal.deer.pos.equals(current.deer.pos))
        {
            best = current.cost.g;
            break;
        }

        {
            DeerCost neighbor = current;
            neighbor.from =  (uint) closed_list.len()-1;
            neighbor.deer.pos.x += neighbor.deer.dir.x;
            neighbor.deer.pos.y += neighbor.deer.dir.y;
            neighbor.op = 1;
            if (grid[neighbor.deer.pos.y][neighbor.deer.pos.x] != '#' && !contains(&closed_list, neighbor))
            {
                uint tentative_g = current.cost.g + 1;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        {
            DeerCost neighbor = current;
            neighbor.op = 2;
            neighbor.from = (uint) closed_list.len()-1;

            if (neighbor.deer.dir.x != 0)
            {
                neighbor.deer.dir.x = 0;
                neighbor.deer.dir.y = 1;
            }
            else
            {
                neighbor.deer.dir.x = 1;
                neighbor.deer.dir.y = 0;
            }

            if (!contains(&closed_list, neighbor))
            {
                uint tentative_g = current.cost.g + 1000;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
        {
            DeerCost neighbor = current;
            neighbor.op = 3;
            neighbor.from = (uint) closed_list.len()-1;

            if (neighbor.deer.dir.x != 0)
            {
                neighbor.deer.dir.x = 0;
                neighbor.deer.dir.y = -1;
            }
            else
            {
                neighbor.deer.dir.x = -1;
                neighbor.deer.dir.y = 0;
            }

            if (!contains(&closed_list, neighbor))
            {
                uint tentative_g = current.cost.g + 1000;
                update_open_list(&open_list, neighbor, goal, tentative_g);
            }
        }
    }

    if (is_part_b)
    {
        List(<uint>) chains;
        defer chains.free();
        chains.push((uint) closed_list.len()-1);

        List(<Vector2>) all_places;
        defer all_places.free();

        while(chains.len() > 0)
        {
            uint! idx = chains.pop();
            if(catch err = idx)
            {
                break;
            }

            DeerCost current = closed_list[idx];
            while(!current.deer.pos.equals(start.deer.pos))
            {
                uint from_index = current.from;
                current = closed_list[from_index];

                if (!all_places.contains(current.deer.pos))
                {
                    all_places.push(current.deer.pos);
                }

                foreach(int i, DeerCost deer_cost : closed_list)
                {
                    if (deer_cost.deer.equals(current.deer) && i != from_index && deer_cost.cost.g == current.cost.g)
                    {
                        chains.push(i);
                    }
                }
            }
        }
       
        return (uint) all_places.len() + 1;
    }

    return best;
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    uint cost = cheapest_path(grid, is_part_b, verbose);
    io::printfn("Total is %d", cost);
}