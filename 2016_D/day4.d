module day4;

import std.conv;
import std.array;
import std.stdio;
import std.algorithm;

struct LetterCount
{
	uint m_count = 0;
	char m_character = 0;
}

int FindIndex(const char to_find, LetterCount[] letter_counts)
{
	for (int i = 0; i < letter_counts.length; i++)
	{
		if (letter_counts[i].m_character == to_find)
		{
			return i;
		}
	}

	return -1;
}

int compare_val(LetterCount a, LetterCount b)
{
	return 100 * (b.m_count - a.m_count) + a.m_character - b.m_character;
}

string ComputeChecksum(string[] lowercases)
{
	LetterCount[] counts;
	foreach(ref string lower; lowercases)
	{
		writefln("Lower %s", lower);

		foreach(char character; lower)
		{
			const int i = FindIndex(character, counts);
			if (i == -1)
			{
				counts ~= LetterCount(0, character); 
			}
			else
			{
				counts[i].m_count++;
			}
		}
	}

	counts.sort!((a,b) => compare_val(a,b) < 0);

	string output;
	foreach(ref LetterCount count; counts)
	{
		output ~= count.m_character;

		if (output.length == 5)
		{
			break;
		}
	}

	writefln("Result %s", output);
	return output;
}


uint ComputeLineValue(string* line)
{
	auto splitted = (*line).split("-");

	string[] lowercases = splitted[0..splitted.length-1];
	string checksum = ComputeChecksum(lowercases);

	string* sector_checksum = &splitted[splitted.length-1];

	auto tmp = (*sector_checksum).split("[");
	string sector = tmp[0];
	string checksum_expected = tmp[1][0..tmp[1].length-2];

	writefln("Sector %s : checksum %s", sector, checksum_expected);

	if(checksum == checksum_expected)
	{
		return sector.to!uint();
	}

	return 0;
}

string ComputeResult(string[] split_string)
{
	uint total = 0;

	foreach(ref string line; split_string)
	{
		total += ComputeLineValue(&line);
	}

	return total.to!string();
}
