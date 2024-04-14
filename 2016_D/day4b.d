module day4b;

import std.conv;
import std.array;
import std.stdio;
import std.algorithm;


void Decrypt(char[][] lowercases, string sector)
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

bool IsRightRoom(char[][] lowercases, string sector)
{
	Decrypt(lowercases, sector);

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

bool ComputeLineValue(string* line, out string sector_name)
{
	auto splitted = (*line).split("-");

	char[][] lowercases;
	for(int i = 0; i < splitted.length - 1; i++)
	{
		lowercases ~= splitted[i].dup;
	}

	string sector_checksum = splitted[splitted.length-1];
	string sector = sector_checksum.split("[")[0];

	if (IsRightRoom(lowercases, sector))
	{
		sector_name = sector;
		return true;
	}
	return false;
}

string ComputeResult(string[] split_string)
{
	string output;
	foreach(ref string line; split_string)
	{
		if (ComputeLineValue(&line, output))
		{
			break;
		}
	}

	return output;
}
