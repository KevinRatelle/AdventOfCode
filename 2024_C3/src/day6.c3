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

// x = 1, y = 0
// x = 0, y = 1
// x = -1, y = 0
// x = 0, y = -1

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

fn bool walk_one_step(String[] map, Cursor* cursor)
{
    map[cursor.y][cursor.x] = 'X';

    Cursor target = *cursor;
    target.x += target.dir_x;
    target.y += target.dir_y;

    // test if exits map
    if (target.x >= map[0].len || target.x < 0 ||
        target.y >= map.len || target.y < 0)
    {
        return true;
    }

    if (map[target.y][target.x] == '#')
    {
        cursor.rotate();
        cursor.x += cursor.dir_x;
        cursor.y += cursor.dir_y;
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

fn void process(String data, bool is_part_b)
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

    guard_walk(map, cursor);

    uint count = count_walked(map);
    io::printfn("Total is %d", count);
}