namespace _2025_Beef;

using System;
using System.Collections;

class Day5
{
	struct Range
	{
		public int64 m_begin;
		public int64 m_end;

		public int64 Length()
		{
			return m_end - m_begin + 1;
		}

		public bool Overlap(Range range)
		{
			return m_begin <= range.m_end && m_end >= range.m_begin;
		}
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

	static int32 Overlap(Range rangeIn, List<Range> ranges, int32 startIndex)
	{
		for (int32 i = startIndex; i < ranges.Count; i++)
		{
			Range range = ranges[i];
			if (range.Overlap(rangeIn))
			{
				return i;
			}
		}

		return -1;
	}

	static void CutOverlaps(ref List<Range> ranges)
	{
		for (int32 i = 0; i < ranges.Count; i++)
		{
			Range range = ranges[i];

			int32 index = 1;
			while (index != -1)
			{
				index = Overlap(range, ranges, i + 1);

				if (index != -1)
				{
					Range otherRange = ranges[index];

					// 4 scenarios

					// completely in the other range : remove range
					if (range.m_end <= otherRange.m_end && range.m_begin >= otherRange.m_begin)
					{
						range.m_begin = 0;
						range.m_end = -1;
					}
					// contains the other completely : split range
					else if (range.m_end >= otherRange.m_end && range.m_begin <= otherRange.m_begin)
					{
						Range newRange;
						newRange.m_begin = otherRange.m_end + 1;
						newRange.m_end = range.m_end;

						range.m_end = otherRange.m_begin - 1;
						ranges.Add(newRange);
					}
					// otherwise either adjust range on left or right
					else if (range.m_end >= otherRange.m_end)
					{
						range.m_begin = otherRange.m_end + 1;
					}
					else
					{
						range.m_end = otherRange.m_begin - 1;
					}
				}
			}

			ranges[i] = range;
		}
	}

	static uint64 CountFreshRange(ref List<Range> ranges)
	{
		CutOverlaps(ref ranges);

		int64 total = 0u;
		for (var range in ranges)
		{
			total += range.Length();
		}

		return (uint64)total;
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

		uint64 count = 0u;
		if (isPartB)
		{
			count = CountFreshRange(ref ranges);
		}
		else
		{
			count = CountFresh(values, ranges);
		}

		Console.WriteLine("Count is {}", count);
	}
}