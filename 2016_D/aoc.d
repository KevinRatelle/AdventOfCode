
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

    uint total = ComputeResult(split_string);
    writefln("total is : %d", total);

    file.close(); 
}