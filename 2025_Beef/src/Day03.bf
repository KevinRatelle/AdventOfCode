namespace _2025_Beef;

using System;
using System.Collections;

class Day03
{
	static uint8 ToDigit(char8 c)
	{
		return (uint8)(c - '0');
	}

	static uint64 Pow(uint64 value, uint8 power)
	{
		if (power == 0)
		{
			return 1;
		}

		return value * Pow(value, power - 1);
	}

	static uint64 ComputeBankJolt(StringView str, uint8 digitCount)
	{
		uint64 maxValue = 0;

		uint8 minIndex = 0u;
		uint8 digitRemaining = digitCount;
		while (digitRemaining > 0)
		{
			uint8 digitMax = 0u;
			for (uint8 i = minIndex; i < (str.Length - digitRemaining + 1); i++)
			{
				uint8 digit = ToDigit(str[i]);
				if (digit > digitMax)
				{
					digitMax = digit;
					minIndex = i + 1; // first encounter of the max
				}
			}

			maxValue += digitMax * Pow(10, --digitRemaining);
		}


		return maxValue;
	}

	static public void Execute(List<String> values, bool isPartB)
	{
		uint64 sum = 0u;

		for (var line in values)
		{
			sum += ComputeBankJolt(line, isPartB ? 12 : 2);
		}

		Console.WriteLine("Sum is {}", sum);
	}
}