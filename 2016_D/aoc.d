
import std.file;
import std.array;
import std.stdio;

import day2;

void main()
{
    File file = File("day2.txt", "r");

    string[] split_string;

    string line;
    while ((line = file.readln()) !is null)
    {
        split_string ~= line;
    }

    const string result = ComputeResult(split_string);
    writefln("Result is : %s", result);

    file.close(); 
}