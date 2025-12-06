namespace _2025_Beef;

using System;
using System.Collections;

class Day06
{
	static void Parse(StringView line, List<uint> row)
	{
		for (var str in line.Split(' '))
		{
			if (str.IsEmpty)
			{
				continue;
			}
			row.Add(uint64.Parse(str));
		}
	}

	static void ComputeResults(List<uint> row1, List<uint> row2, List<uint> row3, List<uint> row4, List<char8> ops, List<uint> results)
	{
		for (int i = 0; i < row1.Count; i++)
		{
			if (ops[i] == '+')
			{
				results.Add(row1[i] + row2[i] + row3[i] + row4[i]);
			}
			else
			{
				results.Add(row1[i] * row2[i] * row3[i] * row4[i]);
			}
		}
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		var row1 = scope List<uint>();
		Parse(lines[0], row1);

		var row2 = scope List<uint>();
		Parse(lines[1], row2);

		var row3 = scope List<uint>();
		Parse(lines[2], row3);

		var row4 = scope List<uint>();
		Parse(lines[3], row4);

		var operators = scope List<char8>();
		for (var str in lines[4].Split(' '))
		{
			if (str.IsEmpty)
			{
				continue;
			}
			operators.Add(str[0]);
		}

		var results = scope List<uint>();
		ComputeResults(row1, row2, row3, row4, operators, results);

		uint sum = 0u;
		for (uint u in results)
		{
			sum += u;
		}

		Console.WriteLine("Count is {}", sum);
	}
}