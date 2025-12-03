namespace _2025_Beef;

using System;
using System.Collections;

class Day3
{
	static uint8 ToDigit(char8 c)
	{
		return (uint8)(c - '0');
	}

	static uint32 ComputeBankJolt(StringView str)
	{
		uint8 maxValue = 0;

		for (int i = 0; i < (str.Length - 1); i++)
		{
			uint8 digit1 = ToDigit(str[i]);

			for (int j = i + 1; j < str.Length; j++)
			{
				uint8 digit2 = ToDigit(str[j]);

				uint8 value = digit1 * 10 + digit2;
				if (value > maxValue)
				{
					maxValue = value;
				}
			}
		}

		return maxValue;
	}

	static public void Execute(List<String> values, bool isPartB)
	{
		uint64 sum = 0u;

		for (var line in values)
		{
			sum += ComputeBankJolt(line);
		}

		Console.WriteLine("Sum is {}", sum);
	}
}