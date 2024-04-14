module day3;

import std.conv;
import std.array;
import std.stdio;

bool TriangleIsPossible(int[] lengths)
{
	for (int i = 0; i < 3; i++)
	{
		int cur_length = lengths[i];

		int other_length = 0;
		for (int j = 1; j < 3; j++)
		{
			const int actual_index = (i + j) % 3;
			other_length += lengths[actual_index];
		}

		if (cur_length >= other_length)
		{
			return false;
		}
	}

	return true;
}

string ComputeResult(string[] split_string)
{
	uint total = 0;

	foreach(ref string str; split_string)
	{
		auto lengths_str = str.split();
		int[3] lengths;
		for(int i = 0; i < 3; i++)
		{
			lengths[i] = to!int(lengths_str[i]);
		}

		if (TriangleIsPossible(lengths))
		{
			writefln("Possible is : %d %d %d", lengths[0], lengths[1], lengths[2]);
			total++;
		}
	}

	return total.to!string();
}
