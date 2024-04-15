module day4b;

import std.conv;
import std.array;
import std.stdio;
import std.algorithm;


void decrypt(char[][] lowercases, string sector)
{
	int sector_id = sector.to!int();
	foreach(ref char[] lowercase; lowercases)
	{
		foreach(ref char lower; lowercase)
		{
			int tmp = lower;
			tmp -= 'a';
			tmp += sector_id;
			tmp = tmp % 26;
			tmp += 'a';
			lower = tmp.to!char();
		}
	}

}

bool is_right_room(char[][] lowercases, string sector)
{
	decrypt(lowercases, sector);

	if (lowercases[0].length >= 5 &&lowercases[0][0..5] == "north")
	{
		string result;
		foreach(ref char[] lowercase; lowercases)
		{
			result ~= " " ~ lowercase;
		}

		writefln("Found : %s", result);
		return true;
	}

	return false;
}

bool compute_line_value(string* line, out string sector_name)
{
	auto splitted = (*line).split("-");

	char[][] lowercases;
	for(int i = 0; i < splitted.length - 1; i++)
	{
		lowercases ~= splitted[i].dup;
	}

	string sector_checksum = splitted[splitted.length-1];
	string sector = sector_checksum.split("[")[0];

	if (is_right_room(lowercases, sector))
	{
		sector_name = sector;
		return true;
	}
	return false;
}

string compute_result(string[] split_string)
{
	string output;
	foreach(ref string line; split_string)
	{
		if (compute_line_value(&line, output))
		{
			break;
		}
	}

	return output;
}
