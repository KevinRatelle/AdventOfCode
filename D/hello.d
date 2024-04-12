import std.array;
import std.stdio;

import std.file;
import std.math;
import std.conv;
import std.range;

enum CardinalPoint : uint
{
    North = 0,
    East = 1,
    South = 2,
    West = 3,
    COUNT = 4
}

enum Direction : int
{
    Left = -1,
    Invalid = 0,
    Right = 1
}

Direction ToDirection(char c)
{
    if (c == 'L')
    {
        return Direction.Left;
    }
    else if (c == 'R')
    {
        return Direction.Right;
    }

    return Direction.Invalid;
}

struct Position
{
    int x = 0;
    int y = 0;
    CardinalPoint orientation = CardinalPoint.North;
}

void UpdatePosition(ref Position current, Direction direction, uint count)
{
    uint idx = cast(uint) current.orientation;
    idx = (idx + cast(int) direction + CardinalPoint.COUNT) % CardinalPoint.COUNT;
    current.orientation = cast(CardinalPoint) idx;

    switch(current.orientation)
    {
        case CardinalPoint.West:
        {
            current.x-=count;
            break;
        }
        case CardinalPoint.East:
        {
            current.x+=count;
            break;
        }
        case CardinalPoint.North:
        {
            current.y+=count;
            break;
        }
        case CardinalPoint.South:
        default:
        {
            current.y-=count;
            break;
        }
    }
}

void main()
{
    File file = File("day1.txt", "r");
    string s = file.readln();

    auto split_string = s.split(", ");

    Position position;
    foreach(ref string str; split_string)
    {
        Direction direction = ToDirection(str[0]);
        string substring = str[1..str.length];
        uint count = to!uint(substring);
        UpdatePosition(position, direction, count);
        writefln("Current : %s %d %s x:%d y:%d", str, count, position.orientation, position.x, position.y);
    }

    uint total = abs(position.x) + abs(position.y);
    writefln("total is : %d", total);

    file.close(); 
}