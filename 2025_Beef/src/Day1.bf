namespace _2025_Beef;

using System;
using System.Collections;

public class Day1
{
	static public void Execute(List<String> values, bool isPartB)
	{
		int32 value = 50;
		int32 count = 0;

		for (var line in values)
		{
			int32 sign = 1;

			if (line[0] == 'L')
			{
				sign = -1;
			}
			else if (line[0] != 'R')
			{
				Console.WriteLine("Error, not R or L as first character.");
			}

			int32 lineValue = int32.Parse(line.Substring(1));

			bool isOnZero = (value == 0);

			if (isPartB)
			{
				count += lineValue / 100;
			}

			lineValue %= 100;

			value += sign * lineValue;
			if (value < 0)
			{
				value += 100;
				if (!isOnZero && isPartB && value != 0)
				{
					count++;
				}
			}
			else if (value > 99)
			{
				value -= 100;
				if (!isOnZero && isPartB && value != 0)
				{
					count++;
				}
			}

			if (value == 0)
			{
				count++;
			}

			Console.WriteLine(line);
			Console.WriteLine(value);
		}

		Console.WriteLine("Total count is {}", count);
	}
}