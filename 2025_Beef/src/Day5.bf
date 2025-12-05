namespace _2025_Beef;

using System;
using System.Collections;

class Day5
{
	struct Range
	{
		public int64 m_begin;
		public int64 m_end;
	}

	static int64 ExtractValue(StringView value)
	{
		let valResult = int64.Parse(value);

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


	static bool IsInRange(int64 value, Range range)
	{
		return value >= range.m_begin && value <= range.m_end;
	}

	static public bool IsFresh(int64 value, List<Range> ranges)
	{
		for (var range in ranges)
		{
			if (IsInRange(value, range))
			{
				return true;
			}
		}

		return false;
	}

	static public uint32 CountFresh(List<int64> values, List<Range> ranges)
	{
		uint32 count = 0u;

		for (var value in values)
		{
			if (IsFresh(value, ranges))
			{
				count++;
			}
		}

		return count;
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		var ranges = scope List<Range>();
		var values = scope List<int64>();

		bool isReadingRanges = true;
		for (int64 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			if (line.Length == 0)
			{
				isReadingRanges = false;
				continue;
			}

			if (isReadingRanges)
			{
				Range range = ExtractRange(line);
				ranges.Add(range);
			}
			else
			{
				int64 value = ExtractValue(line);
				values.Add(value);
			}
		}

		uint32 count = CountFresh(values, ranges);
		Console.WriteLine("Count is {}", count);
	}
}