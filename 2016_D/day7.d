module day7;

import std.conv;
import std.digest.md;
import std.stdio;
import std.regex;
import std.typecons : Yes;

bool is_abba(string part)
{
	for (int i = 0; i < part.length-3; i++)
	{
		if (part[i] != part[i+1] &&
			part[i+1] == part[i+2] &&
			part[i] == part[i+3])
		{
			return true;
		}
	}

	return false;
}

bool supports_TLS(string line)
{
	auto pattern = regex(`([\[\]])`);
	auto parts = line.splitter(pattern);

	bool is_bracket = false;
	bool return_value = false;

	foreach(string p; parts)
	{
		bool bAbba = is_abba(p);
		writefln("%s", p);

		if (bAbba)
		{
			if (is_bracket)
			{
				return false;
			}

			return_value = true;
		}

		is_bracket = !is_bracket;
	}

	return return_value;
}

string compute_result(string[] inputs)
{
	int total = 0;

	foreach(ref string line; inputs)
	{
		if (supports_TLS(line))
		{
			total++;
		}
	}

	return total.to!string();
}
