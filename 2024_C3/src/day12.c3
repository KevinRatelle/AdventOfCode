import std::io;
import std::collections::list;
import std::sort;

struct Position
{
    uint row;
    uint col;
    bool is_low;
}

fn bool Position.equals(Position* this, Position pos)
{
    return (this.row == pos.row) && (this.col == pos.col);
}

fn void append_neighbors(String[] grid, Position pos, List(<Position>)* positions)
{
    char c = grid[pos.row][pos.col];
    grid[pos.row][pos.col] = '.';

    if (positions.contains(pos))
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

fn int remove_chain(List(<Position>)* positions, bool horizontal)
{
    Position position = positions.get(0);
    List(<Position>) same_row;

    for (int j=0; j<positions.len(); j++)
    {
        Position other = positions.get(j);

        if(horizontal && other.row == position.row && other.is_low == position.is_low)
        {
            same_row.push(other);
        }
        else if (!horizontal && other.col == position.col && other.is_low == position.is_low)
        {
            same_row.push(other);
        }
    }

    quicksort(same_row,  fn int (Position* a, Position* b) { return (a.row > b.row || a.col > b.col) ? 1 : -1; });

    int count = 1;
    for (int j = ((int) same_row.len()-1); j>=0; j--)
    {
        if (j>0)
        {
            if (horizontal && (same_row[j].col - same_row[(ulong) j-1].col) > 1)
            {
                count++;
            }
            if (!horizontal && (same_row[j].row - same_row[(ulong) j-1].row) > 1)
            {
                count++;
            }
        }

        ulong! index = positions.index_of(same_row[j]);
        if (catch err = index)
        {
            continue;
        }
        positions.remove_at(index);
    }


    return count;
}

fn ulong count_chains(List(<Position>)* positions, bool horizontal)
{
    ulong count = 0;
    while(positions.len() > 0)
    {
        count += remove_chain(positions, horizontal);
    }

    return count;
}

fn ulong compute_side_count(List(<Position>)* positions)
{
    List(<Position>) horizontals; // zero is on the top of the 0 row
    List(<Position>) verticals; // zero is on the left of the 0 column
    for(int i = 0; i < positions.len(); i++)
    {
        Position pos = positions.get(i);

        bool has_right = true;
        bool has_left = true;

        bool has_up = true;
        bool has_down = true;

        for(int j = 0; j < positions.len(); j++)
        {
            Position other = positions.get(j);
            if (pos.equals(other))
            {
                continue;
            }

            if (pos.row == other.row)
            {
                if ((other.col - pos.col) == 1)
                {
                    has_right = false;
                }
                if ((pos.col - other.col) == 1)
                {
                    has_left = false;
                }
            }

            if (pos.col == other.col)
            {
                if ((other.row - pos.row) == 1)
                {
                    has_down = false;
                }
                if ((pos.row - other.row) == 1)
                {
                    has_up = false;
                }
            }
        }

        if (has_left)
        {
            Position left = pos;
            left.is_low = true;
            verticals.push(left);
        }                
        if (has_right)
        {
            Position right = pos;
            right.col++;
            right.is_low = false;
            verticals.push(right);
        }
        if (has_up)
        {
            Position up = pos;
            up.is_low = true;
            horizontals.push(up);
        }
        if (has_down)
        {
            Position down = pos;
            down.row = pos.row+1;
            down.is_low = false;
            horizontals.push(down);
        }
    }

    ulong horizontals_count = count_chains(&horizontals, true);
    ulong verticals_count = count_chains(&verticals, false);

    ulong side_count = horizontals_count + verticals_count;
    return side_count;
}

fn ulong compute_result(String[] grid, int row, int col, bool is_part_b)
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
    ulong sides = is_part_b ? compute_side_count(&positions) : compute_perimeter(&positions);
    return area * sides;
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
            total += compute_result(grid, row, col, is_part_b);
        }
    }

    io::printfn("Total is %d", total);
}