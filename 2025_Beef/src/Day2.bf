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

	static bool IsInvalid(String str, int groupCount)
	{
		int len = str.Length;
		if (len % groupCount != 0)
		{
			return false;
		}

		int offset = len / groupCount;

		for (int i = 0; i < offset; i++)
		{
			for (int o = 0; o < groupCount; o++)
			{
				int off = o * offset;
				if (str[i] != str[i + off])
				{
					return false;
				}
			}
		}

		return true;
	}


	static bool IsInvalid(String str)
	{
		int len = str.Length;

		for (int groupCount = 2; groupCount <= len; groupCount++)
		{
			if (IsInvalid(str, groupCount))
			{
				return true;
			}
		}

		return false;
	}

	static bool IsInvalid(uint64 value, bool isPartB)
	{
		String str = scope String();
		value.ToString(str);

		if (isPartB)
		{
			return IsInvalid(str);
		}

		return IsInvalid(str, 2);
	}

	static uint64 SumInvalid(Range range, bool isPartB)
	{
		uint64 sum = 0u;
		for (uint64 i = range.m_begin; i <= range.m_end; i++)
		{
			if (IsInvalid(i, isPartB))
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
				sum += SumInvalid(range, isPartB);
			}
		}

		Console.WriteLine("Sum is {}", sum);
	}
}