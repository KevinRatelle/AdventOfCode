import std::io;

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

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    ulong[4] quadrants = {0,0,0,0};
    Vector2 grid;
    grid.x = 101;
    grid.y = 103;
    foreach(String line : lines)
    {
        Robot robot = read_robot(line);
        move_robot(&robot, 100, grid);
        io::printfn("Robot : pos %d %d vel %d %d", robot.pos.x, robot.pos.y, robot.vel.x, robot.vel.y);

        int quadrant_index = compute_quadrant(robot, grid);
        if (quadrant_index != -1)
        {
            quadrants[quadrant_index]++;
        }
    }

    ulong total = quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3];
    io::printfn("Total is %d", total);
}