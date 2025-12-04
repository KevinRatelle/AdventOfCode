namespace _2025_Beef;

using System;
using System.Collections;

class Day4
{
	static public bool IsObject(List<bool> grid, int32 row, int32 col, int32 rowCount, int32 columnCount)
	{
		if (row < 0 || col < 0 || row >= rowCount || col >= columnCount)
		{
			return false;
		}


		return grid[row * columnCount + col];
	}

	static public bool IsMovable(List<bool> grid, int32 row, int32 col, int32 rowCount, int32 columnCount)
	{
		uint32 neighborCount = 0u;

		for (int32 i = -1; i <= 1; i++)
		{
			for (int32 j = -1; j <= 1; j++)
			{
				if (j == 0 && i == 0)
				{
					continue;
				}

				if (IsObject(grid, row + i, col + j, rowCount,  columnCount))
				{
					neighborCount++;
				}
			}
		}

		return neighborCount < 4;
	}

	static public uint32 CountMovableCells(List<bool> grid, int32 rowCount, int32 columnCount)
	{
		uint32 count = 0u;

		for (int32 row = 0u; row < rowCount; row++)
		{
			for (int32 col = 0u; col < columnCount; col++)
			{
				if (!IsObject(grid, row, col, rowCount, columnCount))
				{
					continue;
				}

				if (IsMovable(grid, row, col, rowCount, columnCount))
				{
					count++;
				}
			}
		}

		return count;
	}

	static public void Execute(List<String> values, bool isPartB)
	{
		List<bool> grid = scope List<bool>();
		int32 columnCount = 0u;
		int32 rowCount = 0u;

		for (var line in values)
		{
			if (columnCount == 0u)
			{
				columnCount = (int32)line.Length;
			}

			rowCount++;

			for (int i = 0; i < line.Length; i++)
			{
				char8 c = line[i];
				if (c == '@')
				{
					grid.Add(true);
				}
				else if (c == '.')
				{
					grid.Add(false);
				}
				else
				{
					Runtime.Assert(false);
				}
			}
		}

		uint32 count = CountMovableCells(grid, rowCount, columnCount);

		Console.WriteLine("Count is {}", count);
	}
}