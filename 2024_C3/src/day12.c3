import std::io;
import std::collections::list;

struct Position
{
    uint row;
    uint col;
}

fn bool contains(List(<Position>)* positions, Position pos)
{
    foreach(Position position : positions)
    {
        if (position.col == pos.col && position.row == pos.row)
        {
            return true;
        }
    }

    return false;
}


fn void append_neighbors(String[] grid, Position pos, List(<Position>)* positions)
{
    char c = grid[pos.row][pos.col];
    grid[pos.row][pos.col] = '.';

    if (contains(positions, pos))
    {
        return;
    }

    positions.push(pos);

    Position neighbor = pos;
    if (pos.row > 0 && grid[pos.row-1][pos.col] == c)
    {
        neighbor.row = pos.row - 1;
        neighbor.col = pos.col;
        append_neighbors(grid, neighbor, positions);
    }

    if ((pos.row+1)< grid.len && grid[pos.row+1][pos.col] == c)
    {
        neighbor.row = pos.row + 1;
        neighbor.col = pos.col;
        append_neighbors(grid, neighbor, positions);
    }

    if (pos.col > 0 && grid[pos.row][pos.col-1] == c)
    {
        neighbor.row = pos.row;
        neighbor.col = pos.col - 1;
        append_neighbors(grid, neighbor, positions);
    }

    if ((pos.col+1)< grid[0].len && grid[pos.row][pos.col+1] == c)
    {
        neighbor.row = pos.row;
        neighbor.col = pos.col + 1;
        append_neighbors(grid, neighbor, positions);
    }
}

fn uint compute_perimeter(List(<Position>)* positions)
{
    uint perimeter = 0;

    foreach(Position pos : positions)
    {
        uint neighbor_count = 0;
        foreach(Position other : positions)
        {
            if (pos.col == other.col && pos.row == other.row)
            {
                continue;
            }

            if (($$abs(pos.col - other.col) == 1) && pos.row == other.row)
            {
                neighbor_count++;
            }

            if (pos.col == other.col && ($$abs(pos.row - other.row) == 1))
            {
                neighbor_count++;
            }
        }

        perimeter += (4 - neighbor_count);
    }

    return perimeter;
}

fn ulong compute_result(String[] grid, int row, int col)
{
    char c = grid[row][col];
    if (c == '.')
    {
        return 0;
    }

    List(<Position>) positions;
    Position pos;
    pos.row = row;
    pos.col = col;
    append_neighbors(grid, pos, &positions);

    ulong area = positions.len();
    ulong perimeter = compute_perimeter(&positions);
    return area * perimeter;
}

fn void process(String data, bool is_part_b)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    ulong total = 0;
    for(int row = 0; row < grid.len; row++)
    {
        for (int col = 0; col < grid[0].len; col++)
        {
            total += compute_result(grid, row, col);
        }
    }

    io::printfn("Total is %d", total);
}