
import std.file;
import std.array;
import std.stdio;

import day1;

void main()
{
    File file = File("day1.txt", "r");
    string s = file.readln();

    auto split_string = s.split(", ");

    uint total = ComputeResult(split_string);
    writefln("total is : %d", total);

    file.close(); 
}