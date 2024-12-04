import std::io;

struct Direction
{
    int x;
    int y;
}

fn bool test_direction(String[] lines, int i, int j, Direction dir)
{
    String name = "MAS";

    for (int index = 0; index < 3; index++)
    {
        i += dir.x;
        j += dir.y;

        if (i < 0 || j < 0 || i >= lines.len || j >= lines[0].len)
        {
            return false;
        }

        if (lines[i][j] != name[index])
        {
            return false;
        }
    }

    return true;
}

fn void test_current(String[] lines, int i, int j, uint* count)
{ 
    Direction dir;
    for(dir.x = -1; dir.x <= 1; dir.x++)
    {
        for (dir.y = -1; dir.y <= 1; dir.y++)
        {
            if (test_direction(lines, i, j, dir))
            {
                (*count)++;
            }
        }
    }
}

fn void test_current_x(String[] lines, int i, int j, uint* count)
{
    if (i == 0 || j == 0 || i == (lines.len - 1) || j == (lines[0].len - 1))
    {
        return;
    }

    char[4] corners;
    corners[0] = lines[i-1][j-1];
    corners[1] = lines[i-1][j+1];
    corners[2] = lines[i+1][j+1];
    corners[3] = lines[i+1][j-1];

    uint countM = 0;
    for (int index = 0; index < 4; index++)
    {
        if (corners[index] == 'M')
        {
            countM++;
        }
        else if (corners[index] != 'S')
        {
            return;
        }
    }

    if (countM != 2)
    {
        return;
    }

    if (corners[0] != corners[2])
    {
        (*count)++;
    }
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    uint count = 0;

    // consider the list of strings as a matrix
    for(int i = 0; i < lines.len; i++)
    {
        String line = lines[i];
        for (int j = 0; j < line.len; j++)
        {
            if (is_part_b)
            {
                if (line[j] == 'A')
                {
                    test_current_x(lines, i, j, &count);
                }
            }
            else if (line[j] == 'X')
            {
                test_current(lines, i, j, &count);
            }
        }
    }

    io::printfn("Total is %d", count);
}