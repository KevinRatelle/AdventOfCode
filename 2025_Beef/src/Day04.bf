namespace _2025_Beef;

using System;
using System.Collections;

class Day04
{
	static public bool IsObject(List<char8> grid, int32 row, int32 col, int32 rowCount, int32 columnCount)
	{
		if (row < 0 || col < 0 || row >= rowCount || col >= columnCount)
		{
			return false;
		}

		char8 c = grid[row * columnCount + col];
		return c == '@' || c == 'x';
	}

	static public bool IsMovable(List<char8> grid, int32 row, int32 col, int32 rowCount, int32 columnCount)
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

	static public void FlagMovableCells(List<char8> grid, int32 rowCount, int32 columnCount)
	{
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
					grid[row * columnCount + col] = 'x';
				}
			}
		}
	}

	static public uint32 RemoveMovableCells(List<char8> grid, int32 rowCount, int32 columnCount)
	{
		uint32 count = 0u;
		for (int32 row = 0u; row < rowCount; row++)
		{
			for (int32 col = 0u; col < columnCount; col++)
			{
				if (grid[row * columnCount + col] == 'x')
				{
					grid[row * columnCount + col] = '.';
					count++;
				}
			}
		}

		return count;
	}

	static public void Execute(List<String> values, bool isPartB)
	{
		List<char8> grid = scope List<char8>();
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
				if (c == '@' || c == '.')
				{
					grid.Add(c);
				}
				else
				{
					Runtime.Assert(false);
				}
			}
		}

		uint32 count = 0u;

		uint32 removedCount = 1;
		while (removedCount > 0)
		{
			FlagMovableCells(grid, rowCount, columnCount);
			removedCount = RemoveMovableCells(grid, rowCount, columnCount);

			count += removedCount;

			if (!isPartB)
			{
				break;
			}
		}

		Console.WriteLine("Count is {}", count);
	}
}