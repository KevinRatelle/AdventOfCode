namespace _2025_Beef;

using System;
using System.Collections;

class Day07
{
	struct Grid
	{
		public List<char8> m_data;
		public List<uint64> m_counts;
		public uint32 m_rows;
		public uint32 m_cols;

		public ref char8 Get(uint32 row, uint32 col)
		{
			return ref m_data[row * m_cols + col];
		}

		public ref uint64 GetCount(uint32 row, uint32 col)
		{
			return ref m_counts[row * m_cols + col];
		}

		public void Print(bool count = false)
		{
			for (uint32 row in 0 ... m_rows - 1)
			{
				for (uint32 col in 0 ... m_cols - 1)
				{
					uint32 index = row * m_cols + col;

					if (m_data[index] == '|' && count)
					{
						Console.Write(m_counts[index]);
					}
					else
					{
						Console.Write(m_data[index]);
					}
				}

				Console.WriteLine();
			}

			Console.WriteLine();
		}
	}

	static void ProcessBeam(ref Grid grid, ref uint32 splitCount, uint32 row = 0u)
	{
		if (row == 0)
		{
			// do nothing
		}
		else if (row == 1)
		{
			for (uint32 col = 0; col < grid.m_cols; col++)
			{
				if (grid.Get(row - 1, col) == 'S')
				{
					grid.Get(row, col) = '|';
				}
			}

			// grid.Print();
		}
		else if (row == grid.m_rows)
		{
			return;
		}
		else
		{
			for (uint32 col = 0; col < grid.m_cols; col++)
			{
				if (grid.Get(row - 1, col) == '|')
				{
					if (grid.Get(row, col) == '^')
					{
						splitCount++;

						if (col > 0)
						{
							grid.Get(row, col - 1) = '|';
						}

						if (col < (grid.m_cols - 1))
						{
							grid.Get(row, col + 1) = '|';
						}
					}
					else
					{
						grid.Get(row, col) = '|';
					}
				}
			}

			//grid.Print();
		}

		ProcessBeam(ref grid, ref splitCount, row + 1);
	}

	static void ProcessCountsInternal(ref Grid grid, uint32 row = 1)
	{
		if (row == grid.m_rows)
		{
			return;
		}

		for (uint32 col = 0u; col < grid.m_cols; col++)
		{
			if (grid.Get(row, col) != '|')
			{
				continue;
			}

			if (grid.Get(row - 1, col) == 'S')
			{
				grid.GetCount(row, col) = 1;
				continue;
			}

			grid.GetCount(row, col) += grid.GetCount(row - 1, col);

			if (col > 0 && grid.Get(row, col - 1) == '^')
			{
				grid.GetCount(row, col) += grid.GetCount(row - 1, col - 1);
			}

			if (col < (grid.m_cols - 1) && grid.Get(row, col + 1) == '^')
			{
				grid.GetCount(row, col) += grid.GetCount(row - 1, col + 1);
			}
		}

		//grid.Print(true);
		ProcessCountsInternal(ref grid, row + 1);
	}

	static uint64 ProcessCounts(ref Grid grid)
	{
		ProcessCountsInternal(ref grid);

		uint32 row = grid.m_rows - 1;
		uint64 count = 0u;
		for (uint32 col = 0; col < grid.m_cols; col++)
		{
			count += grid.GetCount(row, col);
		}
		return count;
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		Grid grid;
		grid.m_data = scope List<char8>();
		grid.m_counts = scope List<uint64>();
		grid.m_rows = (uint32)lines.Count;
		grid.m_cols = (uint32)lines[0].Length;

		for (int32 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			for (int32 j = 0; j < line.Length; j++)
			{
				grid.m_data.Add(line[j]);
				grid.m_counts.Add(0u);
			}
		}

		// grid.Print();

		uint32 count = 0u;
		ProcessBeam(ref grid, ref count);

		if (!isPartB)
		{
			Console.WriteLine("Count is {}", count);
		}
		else
		{
			uint64 total = ProcessCounts(ref grid);
			Console.WriteLine("Total is {}", total);
		}
	}
}