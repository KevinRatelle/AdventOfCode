module day9;

import std.conv;
import std.stdio;
import std.string;

string decompress(string line)
{
	char[] output;

	int index = 0;
	while(index < line.length)
	{
		char current = line[index];
		if (current == '(')
		{
			index++;

			long end_index = indexOf(line[index..$], ")") + index;

			auto splitted = line[index..end_index].split("x");
			int char_count = splitted[0].to!int();
			int repeat = splitted[1].to!int();

			index = cast(int) end_index+1;

			string to_copy = line[index..index+char_count];

			for (int i = 0; i < repeat; i++)
			{
				output ~= to_copy;
			}

			index+=char_count;

			continue;
		}

		output ~= current;
		index++;
	}

	return output.to!string();
}

string compute_result(string[] inputs)
{
	int output = 0;

	foreach(ref string line; inputs)
	{
		string decompressed = decompress(line[0..$-1]);

		writefln("%s : %d", decompressed, decompressed.length);

		output+=decompressed.length;
	}

	return output.to!string();
}
