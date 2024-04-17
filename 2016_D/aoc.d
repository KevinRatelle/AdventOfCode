
import std.file;
import std.array;
import std.stdio;

import day10;

void main()
{
    File file = File("day10.txt", "r");

    string[] split_string;

    string line;
    while ((line = file.readln()) !is null)
    {
        split_string ~= line;
    }

    const string result = compute_result(split_string);
    writefln("Result is : %s", result);

    file.close(); 
}