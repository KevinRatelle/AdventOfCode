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

    void move(char direction)
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
    }

    bool is_valid() const
    {
        return ( abs(x) + abs(y) ) <= 2;
    }

    string button_value() const
    {
        const int y_off = (abs(y) == 1) ? 4 : 6;
        const int result = 7 + x + y_off * y;

        if (result == 10)
        {
            return "A";
        }
        if (result == 11)
        {
            return "B";
        }
        if (result == 12)
        {
            return "C";
        }
        if (result == 13)
        {
            return "D";
        }

        assert(result < 10 && result > 0);
        return result.to!string();
    }

}


void move(ref string directions, ref Location location)
{
    foreach(char dir; directions)
    {
        Location loc_copy = location;
        loc_copy.move(dir);

        if (loc_copy.is_valid())
        {
            location = loc_copy;
        }
    }
}

string compute_result(string[] split_string)
{
    string output;
    Location location = Location(0,0);

    foreach(ref string str; split_string)
    {
        move(str, location);
        output ~= location.button_value();
    }

	return output;
}
