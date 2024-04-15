module day3;

import std.conv;
import std.array;
import std.stdio;

bool triangle_is_possible(int[] lengths)
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

string compute_result(string[] split_string)
{
	uint total = 0;

	for(int row = 0; row < split_string.length; row+=3)
	{
		auto row1 = split_string[row].split();
		auto row2 = split_string[row+1].split();
		auto row3 = split_string[row+2].split();

		for (int col = 0; col < 3; col++)
		{
			int[3] lengths;
			lengths[0] = to!int(row1[col]);
			lengths[1] = to!int(row2[col]);
			lengths[2] = to!int(row3[col]);

			if (triangle_is_possible(lengths))
			{
				total++;
			}
		}
	}

	return total.to!string();
}
