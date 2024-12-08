
import std::io;
import std::collections::map;
import std::collections::list;

fn bool is_alpha_numeric(char c)
{
    return c >= 'a' && c <= 'z' ||
           c >= 'A' && c <= 'Z' ||
           c >= '0' && c <= '9';
}

fn void compute_antinodes_one_pair(String[] antinodes_grid, uint i, uint j, uint i2, uint j2)
{
    int offset_x = (int) j - (int) j2;
    int offset_y = (int) i - (int) i2;

    int a = (int) i + offset_y;
    int b = (int) j + offset_x;
    int c = (int) i2 - offset_y;
    int d = (int) j2 - offset_x;

    if (a >= 0 && a < antinodes_grid.len && b >= 0 && b < antinodes_grid[0].len)
    {
        antinodes_grid[a][b] = '#';
    }

    if (c >= 0 && c < antinodes_grid.len && d >= 0 && d < antinodes_grid[0].len)
    {
        antinodes_grid[c][d] = '#';
    }
}

fn void compute_antinodes_one_pair_harmonic(String[] antinodes_grid, int i, int j, int i2, int j2)
{
    int offset_x = (int) j - (int) j2;
    int offset_y = (int) i - (int) i2;

    do 
    {
        antinodes_grid[i][j] = '#';
        i += offset_y;
        j += offset_x;
    } while (i >= 0 && i < antinodes_grid.len && j >= 0 && j < antinodes_grid[0].len);

    do
    {
        antinodes_grid[i2][j2] = '#';
        i2 -= offset_y;
        j2 -= offset_x;
    } while (i2 >= 0 && i2 < antinodes_grid.len && j2 >= 0 && j2 < antinodes_grid[0].len);
}

fn void compute_antinodes_one_char(String[] grid, String[] antinodes_grid, char c, uint i, uint j, bool is_part_b)
{
    for (int row = 0; row < grid.len; row++)
    {
        for (int col = 0; col < grid[0].len; col++)
        {
            if (row == i && col == j)
            {
                continue;
            }

            char other = grid[row][col];
            if (other == c)
            {
                if (is_part_b)
                {
                    compute_antinodes_one_pair_harmonic(antinodes_grid, i, j, row, col);
                }
                else
                {
                    compute_antinodes_one_pair(antinodes_grid, i, j, row, col);
                }
            }
        }
    }
}

fn void compute_antinodes(String[] grid, String[] antinodes_grid, bool is_part_b)
{
    for (int row = 0; row < grid.len; row++)
    {
        for (int col = 0; col < grid[0].len; col++)
        {
            char c = grid[row][col];

            if (is_alpha_numeric(c))
            {
                compute_antinodes_one_char(grid, antinodes_grid, c, row, col, is_part_b);
            }
        }
    }
}

fn uint count_antinodes(String[] antinodes_grid)
{
    uint count = 0;

    foreach(String str : antinodes_grid)
    {
        foreach(char c : str)
        {
            if (c == '#')
            {
                count++;
            }
        }
    }

    return count;
}

fn void print(String[] grid)
{
    foreach(String str : grid)
    {
        io::printn(str);
    }
}

fn void process(String data, bool is_part_b)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    List(<String>) antinodes_grid;
    for(int i = 0; i < grid.len; i++)
    {
        antinodes_grid.push(grid[i].copy());
    }
    defer
    {
        for(int i = 0; i < grid.len; i++)
        {
            antinodes_grid[i].free();
        }
        antinodes_grid.free();
    }

    compute_antinodes(grid, antinodes_grid.to_tarray(), is_part_b);
    print(antinodes_grid.to_tarray());

    uint total = count_antinodes(antinodes_grid.to_tarray());
    io::printfn("Total is %d", total);
}