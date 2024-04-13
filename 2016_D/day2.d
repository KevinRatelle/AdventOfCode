module day2;

import std.math;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.container.array;

struct Location
{
	int x = 0;
	int y = 0;

    void Move(char direction)
    {
        switch(direction)
        {
            case 'U':
            {
                y--;
                break;
            }
            case 'D':
            {
                y++;
                break;
            }
            case 'L':
            {
                x--;
                break;
            }
            case 'R':
            {
                x++;
                break;
            }
            default:
            {
                break;
            }
        }

        Clamp();
    }

    void Clamp()
    {
        x = min(max(0,x), 2);
        y = min(max(0,y), 2);
    }
}

char ButtonValue(Location location)
{
    return to!char(location.x + 1 + 3 * location.y);
}

Location Move(ref string directions, ref Location location)
{
    foreach(char dir; directions)
    {
        location.Move(dir);
    }

    return location;
}

uint ComputeResult(string[] split_string)
{
    uint val = 0;
    Location location = Location(1,1);

    foreach(ref string str; split_string)
    {
        Move(str, location);
        val = val * 10 + ButtonValue(location);
    }

	return val;
}

uint ComputeResult_PartB(string[] split_string)
{
    uint val = 0;
	return val;
}
