import std::io;
import std::collections::list;

struct Position
{
    int col;
    int row;
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

fn void check_possibilities(String[] grid, Position current, List(<Position>)* tails, bool is_part_b)
{
    int current_value = grid[current.row][current.col];
    for(int i = -1; i<=1; i++)
    {
        Position neighbor;
        neighbor.row = current.row + i;
        if (neighbor.row < 0 || neighbor.row >= grid.len)
        {
            continue;
        }

        for(int j = -1; j<=1; j++)
        {
            if (j == 0 && i == 0)
            {
                continue;
            }

            if (j != 0 && i != 0)
            {
                continue;
            }

            neighbor.col = current.col + j;
            if (neighbor.col < 0 || neighbor.col >= grid[0].len)
            {
                continue;
            }

            if (grid[neighbor.row][neighbor.col] == (current_value+1))
            {
                if ((current_value+1) == '9' && (!contains(tails, neighbor) || is_part_b))
                {
                    tails.push(neighbor);
                }
                else
                {
                    check_possibilities(grid, neighbor, tails, is_part_b);
                }
            }
        }
    }
}

fn uint compute_score(String[] grid, Position head, bool is_part_b)
{
    List(<Position>) tails;
    defer tails.free();

    check_possibilities(grid, head, &tails, is_part_b);

    return (uint) tails.len();
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] grid = data.split("\r\n");
	defer free(grid);

    List(<Position>) heads;
    for(int row = 0; row < grid.len; row++)
    {
        for(int col = 0; col < grid[0].len; col++)
        {
            if (grid[row][col] == '0')
            {
                Position head;
                head.col = col;
                head.row = row;
                heads.push(head);
            }
        }
    }

    uint total_score = 0;
    foreach(Position head : heads)
    {
        uint score = compute_score(grid, head, is_part_b);
        total_score += score;
    }

    io::printfn("Total is %d", total_score);
}