import std::io;
import std::collections::list;

struct Vector2
{
    long x;
    long y;
}

struct Robot
{
    Vector2 pos;
    Vector2 vel;
}

fn Robot read_robot(String line)
{
    Robot robot;
    String[] temp = line.split(" ");
    defer free(temp);

    String[] position_string = temp[0].split("=");
    String[] velocity_string = temp[1].split("=");
    defer free(position_string);
    defer free(velocity_string);

    String[] pos_str = position_string[1].split(",");
    String[] vel_str = velocity_string[1].split(",");
    defer free(pos_str);
    defer free(vel_str);

    String px_str = pos_str[0];
    String py_str = pos_str[1];
    String vx_str = vel_str[0];
    String vy_str = vel_str[1];

    ulong! px = px_str.to_ulong();
    if (catch err = px)
    {
        return robot;
    }

    ulong! py = py_str.to_ulong();
    if (catch err = py)
    {
        return robot;
    }

    long! vx = vx_str.to_long();  
    if (catch err = vx)
    {
        return robot;
    }

    long! vy = vy_str.to_long();
    if (catch err = vy)
    {
        return robot;
    }

    Vector2 pos;
    pos.x = px;
    pos.y = py;

    Vector2 vel;
    vel.x = vx;
    vel.y = vy;

    robot.pos = pos;
    robot.vel = vel;

    return robot;
}

fn void move_robot(Robot* robot, ulong steps, Vector2 grid)
{
    robot.pos.x += robot.vel.x * steps;
    robot.pos.y += robot.vel.y * steps;

    robot.pos.x = robot.pos.x % grid.x;
    robot.pos.y = robot.pos.y % grid.y;

    if (robot.pos.x < 0)
    {
        robot.pos.x += grid.x;
    }

    if (robot.pos.y < 0)
    {
        robot.pos.y += grid.y;
    }
}

fn int compute_quadrant(Robot robot, Vector2 grid)
{
    Vector2 center;
    center.x = (grid.x-1) / 2;
    center.y = (grid.y-1) / 2;

    if (robot.pos.x == center.x || robot.pos.y == center.y)
    {
        return -1;
    }

    int quadrant = 0;
    if (robot.pos.x > center.x)
    {
        quadrant += 1;
    }
    if (robot.pos.y > center.y)
    {
        quadrant += 2;
    }

    return quadrant;
}


fn void set_grid(List(<String>)* image, List(<Robot>)* robots)
{
    for(int i = 0; i < image.len(); i++)
    {
        for(int j = 0; j < image.get(i).len; j++)
        {
            ZString str = (ZString) image.get(i);
            str[j] = '.';
        }
    }

    for (int i = 0; i<robots.len(); i++)
    {
        Robot robot = robots.get(i);
        image.get(robot.pos.y)[robot.pos.x] = 'X';
    }
}

fn void print_grid(List(<String>)* image)
{
    for(int i = 0; i < image.len(); i++)
    {
        String str = image.get(i);
        io::printfn(str);
    }
}

fn uint tree_heuristic(List(<Robot>)* robots)
{
    uint heuristic = 0;
    for(int i = 0; i < robots.len(); i++)
    {
        Robot a = robots.get(i);
        for (int j = i+1; j < robots.len(); j++)
        {
            Robot b = robots.get(j);
            if ($$abs((int) a.pos.x - (int) b.pos.x) == 1)
            {
                heuristic++;
            }

            if ($$abs((int) a.pos.y - (int) b.pos.y) == 1)
            {
                heuristic++;
            }
        }
    }

    return heuristic;
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    Vector2 grid;
    grid.x = 101;
    grid.y = 103;

    if (!is_part_b)
    {
        ulong[4] quadrants = {0,0,0,0};

        foreach(String line : lines)
        {
            Robot robot = read_robot(line);
            move_robot(&robot, 100, grid);

            if (verbose)
            {
                io::printfn("Robot : pos %d %d vel %d %d", robot.pos.x, robot.pos.y, robot.vel.x, robot.vel.y);
            }

            int quadrant_index = compute_quadrant(robot, grid);
            if (quadrant_index != -1)
            {
                quadrants[quadrant_index]++;
            }
        }

        ulong total = quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3];
        io::printfn("Total is %d", total);
    }
    else
    {
        List(<String>) image;
        defer image.free();

        for(int i = 0; i < grid.y; i++)
        {
            String str = "";
            image.push(str);

            for (int j = 0; j < grid.x; j++)
            {
                image[i] = image[i].concat(".");
            }
        }

        List(<Robot>) robots;
        foreach(String line : lines)
        {
            Robot robot = read_robot(line);
            robots.push(robot);
        }

        uint frame = 0;
        uint best_frame = 0;
        uint tree_probability = 0;
        while (++frame < 20000)
        {
            if (verbose && frame % 1000 == 0)
            {
                io::printfn("Second = %d", frame);
            }

            foreach(Robot* &robot : robots)
            {
                move_robot(robot, 1, grid);
            }

            uint current_tree_probability = tree_heuristic(&robots);
            if (current_tree_probability > tree_probability)
            {
                if (verbose)
                {
                    io::printfn("Second = %d", frame);
                    set_grid(&image, &robots);
                    print_grid(&image);
                }
                tree_probability = current_tree_probability;
                best_frame = frame;
            }
        }

        io::printfn("Best frame is %d", best_frame);
    }
}