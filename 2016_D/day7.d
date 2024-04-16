module day7;

import std.conv;
import std.digest.md;
import std.stdio;
import std.regex;
import std.typecons : Yes;

bool is_aba_bab(string s, string[] arr)
{
	for (int i = 1; i < s.length-1; i++)
	{
		if (s[i-1] == s[i+1])
		{
			foreach (string a; arr)
			{
				for (int j = 1; j < a.length-1; j++)
				{
					if (a[j-1] == s[i] && a[j+1] == s[i] && a[j] == s[i-1])
					{
						return true;
					}
				}
			}
		}
	}

	return false;
}

bool supports_TLS(string line)
{
	auto pattern = regex(`([\[\]])`);
	auto parts = line.splitter(pattern);

	string[] supernet;
	string[] hypernet;

	bool is_bracket = false;

	foreach(string p; parts)
	{
		if (is_bracket)
		{
			supernet ~= p;
		}
		else
		{
			hypernet ~= p;
		}

		is_bracket = !is_bracket;
	}

	foreach(string s;  supernet)
	{
		if (is_aba_bab(s, hypernet))
		{
			return true;
		}
	}

	return false;
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
