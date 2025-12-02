namespace _2025_Beef;

using System;
using System.Collections;

public class Day2
{
	struct Range
	{
		public uint64 m_begin;
		public uint64 m_end;
	}

	static bool IsInvalid(uint64 value)
	{
		String str = scope String();
		value.ToString(str);

		int len = str.Length;
		if (len % 2 != 0)
		{
			return false;
		}

		int half = len / 2;

		for (int i = 0; i < half; i++)
		{
			if (str[i] != str[i + half])
			{
				return false;
			}
		}

		return true;
	}

	static uint64 SumInvalid(Range range)
	{
		uint64 sum = 0u;
		for (uint64 i = range.m_begin; i <= range.m_end; i++)
		{
			if (IsInvalid(i))
			{
				sum += i;
			}
		}
		return sum;
	}

	static uint64 ExtractValue(StringView value)
	{
		let valResult = uint64.Parse(value);

		switch (valResult)
		{
		case .Ok(let val):
			{
				return val;
			}
		case .Err:
			{
				return 0u;
			}
		}
	}

	static Range ExtractRange(StringView elem)
	{
		Range range;
		range.m_begin = 0;
		range.m_end = 0;

		StringSplitEnumerator enumerator = elem.Split('-');
		Result<StringView> nextResult = enumerator.GetNext();
		switch (nextResult)
		{
		case .Ok(let val):
			{
				range.m_begin = ExtractValue(val);
			}
		case .Err(void err):
			{
				return range;
			}
		}


		nextResult = enumerator.GetNext();
		switch (nextResult)
		{
		case .Ok(let val):
			{
				range.m_end = ExtractValue(val);
			}
		case .Err(void err):
			{
				return range;
			}
		}

		return range;
	}

	static public void Execute(List<String> values, bool isPartB)
	{
		uint64 sum = 0u;

		for (var line in values)
		{
			Console.WriteLine(line);

			for (let elem in line.Split(','))
			{
				Range range = ExtractRange(elem);
				Console.Write(range.m_begin);
				Console.Write("-");
				Console.WriteLine(range.m_end);
				sum += SumInvalid(range);
			}
		}

		Console.WriteLine("Sum is {}", sum);
	}
}