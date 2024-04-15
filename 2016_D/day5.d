module day5;

import std.conv;
import std.digest.md;
import std.stdio;

string compute_result(string input)
{
	int counter = 0;
	char[8] result = ['-','-','-','-','-','-','-','-'];
	int found = 0;

	while(found < 8)
	{
		ubyte[16] hash = md5Of(input ~ counter.to!string());
		char[32] str = toHexString(hash);
		if (str[0..5] == "00000")
		{
			int index = str[5] - '0';
			if (index < result.length && result[index] == '-')
			{
				result[index] = str[6];
				writefln("%s", result);
				found++;
			}
		}

		counter++;
	}

	return result.to!string();
}
