module day9;

import std.conv;
import std.stdio;
import std.string;

ulong decompressed_size(string line)
{
	ulong size = 0;
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

			size += repeat * char_count;

			index+=char_count;

			continue;
		}

		index++;
	}

	return size;
}

string compute_result(string[] inputs)
{
	int output = 0;

	foreach(ref string line; inputs)
	{
		ulong size = decompressed_size(line[0..$-1]);
		writefln("%d", size);
		output+=size;
	}

	return output.to!string();
}
