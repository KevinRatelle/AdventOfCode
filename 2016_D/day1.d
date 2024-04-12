module day1;

import std.math;
import std.conv;
import std.range;
import std.stdio;
import std.container.array;

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

struct Location
{
	int x = 0;
	int y = 0;
}

struct Position
{
    int x = 0;
    int y = 0;
    CardinalPoint orientation = CardinalPoint.North;
}

void UpdateOrientation(ref Position current, Direction direction)
{
    uint idx = cast(uint) current.orientation;
    idx = (idx + cast(int) direction + CardinalPoint.COUNT) % CardinalPoint.COUNT;
    current.orientation = cast(CardinalPoint) idx;
}

void Move(ref Position current, const uint count)
{
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

void UpdatePosition(ref Position current, Direction direction, uint count)
{
	UpdateOrientation(current, direction);
	Move(current, count);
}

uint ComputeResult(string[] split_string)
{
    Position position;
    foreach(ref string str; split_string)
    {
        Direction direction = ToDirection(str[0]);
        string substring = str[1..str.length];
        uint count = to!uint(substring);
        UpdatePosition(position, direction, count);
    }

    const uint total = abs(position.x) + abs(position.y);
	return total;
}

uint ComputeResult_PartB(string[] split_string)
{
	auto locations = Array!Location();

    Position position;
    foreach(ref string str; split_string)
    {
        Direction direction = ToDirection(str[0]);
        string substring = str[1..str.length];
        uint count = to!uint(substring);

		UpdateOrientation(position, direction);
		bool alreadyExist = false;

		for (int i = 0; i < count; i++)
		{
			Move(position, 1);

			foreach(ref Location pos; locations)
			{
				if (pos.x == position.x && pos.y == position.y)
				{
					alreadyExist = true;
					break;
				}
			}

			if (alreadyExist)
			{
				break;
			}

			locations.insert(Location(position.x, position.y));
			
		}

		if (alreadyExist)
		{
			break;
		}
    }

    const uint total = abs(position.x) + abs(position.y);
	return total;
}
