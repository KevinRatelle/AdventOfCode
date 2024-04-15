module day5;

import std.conv;
import std.digest.md;
import std.stdio;

string ComputeResult(string input)
{
	int counter = 0;
	string result;


	while(result.length < 8)
	{
		ubyte[16] hash = md5Of(input ~ counter.to!string());
		char[32] str = toHexString(hash);
		if (str[0..5] == "00000")
		{
			result ~= str[5];
			writefln("%s", result);
		}

		counter++;
	}

	return result;
}
