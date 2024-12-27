import std::io;
import std::collections::list;

struct Cursor
{
    int dir_x;
    int dir_y;
    int x;
    int y;
}

fn void Cursor.rotate(Cursor* this)
{
    if (this.dir_x == 1)
    {
        this.dir_x = 0;
        this.dir_y = 1;
    }
    else if (this.dir_x == -1)
    {
        this.dir_x = 0;
        this.dir_y = -1;
    }
    else if (this.dir_y == 1)
    {
        this.dir_x = -1;
        this.dir_y = 0;
    }
    else // this.dir_y == -1
    {
        this.dir_x = 1;
        this.dir_y = 0;
    }
}

fn bool Cursor.is_horizontal(Cursor* this)
{
    return this.dir_y == 0;
}

fn uint count_walked(String[] map)
{
    uint total = 0;
    foreach(String row : map)
    {
        foreach(char item : row)
        {
            if (item == 'X')
            {
                total++;
            }
        }
    }

    return total;
}

fn bool walk_one_step(String[] map, Cursor* cursor, bool* has_loop = null)
{
    if (has_loop == null)
    {
        map[cursor.y][cursor.x] = 'X';
    }

    Cursor target = *cursor;
    target.x += target.dir_x;
    target.y += target.dir_y;

    // test if exits map
    if (target.x >= map[0].len || target.x < 0 ||
        target.y >= map.len || target.y < 0)
    {
        return true;
    }

    if (map[target.y][target.x] == '#' || map[target.y][target.x] == 'O')
    {
        if (has_loop != null)
        {
            switch (map[cursor.y][cursor.x])
            {
                case '.':
                {
                    if (cursor.is_horizontal())
                    {
                        map[cursor.y][cursor.x] = '-';
                    }
                    else
                    {
                        map[cursor.y][cursor.x] = '|';
                    }
                }
                case '+':
                {
                    *has_loop = true;
                    return true;
                }
                case '-':
                {
                    if (cursor.is_horizontal())
                    {
                        *has_loop = true;
                        return true;
                    }
                    else
                    {
                        map[cursor.y][cursor.x] = '+';
                    }
                }
                case '|':
                {
                    if (cursor.is_horizontal())
                    {
                        map[cursor.y][cursor.x] = '+';
                    }
                    else
                    {
                        *has_loop = true;
                        return true;
                    }
                }
            }
        }

        // just rotate, do not advance as it might be in front of another blocker
        cursor.rotate();
    }
    else
    {
        *cursor = target;
    }

    return false;
}

fn void guard_walk(String[] map, Cursor cursor)
{
    bool exits = false;
    while(!exits)
    {
        exits = walk_one_step(map, &cursor);
    }
}

fn bool guard_walk_detect_loop(String[] map, Cursor cursor)
{
    bool exits = false;
    bool has_loop = false;
    while(!exits)
    {
        exits = walk_one_step(map, &cursor, &has_loop);
    }

    return has_loop;
}


fn void clean_grid(String[] map)
{
    for(int i = 0; i < map.len; i++)
    {
        for(int j = 0; j < map[0].len; j++)
        {
            if (map[i][j] != '#')
            {
                map[i][j] = '.';
            }
        }
    }
}

fn void print_grid(String[] map)
{
    io::printn("---------------------");
    foreach(String line : map)
    {
        io::printn(line);
    }
    io::printn("                     ");
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] map = data.split("\r\n");
	defer free(map);

    Cursor cursor;

    for(int i = 0; i < map.len; i++)
    {
        for(int j = 0; j < map[0].len; j++)
        {
            if (map[i][j] == '^')
            {
                cursor.dir_x = 0;
                cursor.dir_y = -1;
                cursor.y = i;
                cursor.x = j;
            }
        }
    }

    uint count = 0;
    if (is_part_b)
    {
        for(int i = 0; i < map.len; i++)
        {
            if (verbose)
            {
                io::printfn("   - step %d of %d", i+1, map.len);
            }

            for(int j = 0; j < map[0].len; j++)
            {
                clean_grid(map);

                if (map[i][j] == '#' || (i==cursor.y && j==cursor.x))
                {
                    continue;
                }
            
                map[i][j] = 'O';

                // cursor is copied, all good to start over multiple times
                if (guard_walk_detect_loop(map, cursor))
                {
                    count++;
                }

                map[i][j] = '.';
            }
        }
    }
    else
    {
        guard_walk(map, cursor);
        count = count_walked(map);
    }

    map[cursor.y][cursor.x] = '^';

    io::printfn("Total is %d", count);
}