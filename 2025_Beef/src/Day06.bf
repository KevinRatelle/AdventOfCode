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

	static uint ComputeDigit(char8 c)
	{
		if (c.IsWhiteSpace)
		{
			return 0u;
		}

		return (uint)(c - '0');
	}

	static uint ComputeNumber(char8 a, char8 b, char8 c)
	{
		uint d1 = ComputeDigit(a);
		uint d2 = ComputeDigit(b);
		uint d3 = ComputeDigit(c);

		if (d3 != 0)
		{
			return d3 + d2 * 10 + d1 * 100;
		}

		if (d2 != 0)
		{
			return d2 + d1 * 10;
		}

		return d1;
	}

	static uint ComputeNumber(char8 a, char8 b, char8 c, char8 d)
	{
		uint d1 = ComputeDigit(a);
		uint d2 = ComputeDigit(b);
		uint d3 = ComputeDigit(c);
		uint d4 = ComputeDigit(d);

		if (d4 != 0)
		{
			return d4 + d3 * 10 + d2 * 100 + d1 * 1000;
		}

		if (d3 != 0)
		{
			return d3 + d2 * 10 + d1 * 100;
		}

		if (d2 != 0)
		{
			return d2 + d1 * 10;
		}

		return d1;
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		if (!isPartB)
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
		else
		{
			int count = lines[0].Length;
			char8 op = '+';
			uint cur = 0u;
			uint sum = 0u;

			for (int i = 0;; i++)
			{
				if (lines[4][i] != ' ')
				{
					op = lines[4][i];
					sum += cur;

					if (op == '+')
					{
						cur = 0u;
					}
					else
					{
						cur = 1u;
					}
				}

				uint num = ComputeNumber(lines[0][i], lines[1][i], lines[2][i], lines[3][i]);
				if (op == '+')
				{
					cur += num;
				}
				else if (num != 0)
				{
					cur *= num;
				}

				if (i == (count - 1))
				{
					sum += cur;
					break;
				}
			}

			Console.WriteLine("Count is {}", sum);
		}
	}
}