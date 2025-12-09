namespace _2025_Beef;

using System;
using System.Collections;

class Day09
{
	struct Position
	{
		public uint32 x;
		public uint32 y;

		public this
		{
			x = 0;
			y = 0;
		}
	}

	static public int64 ComputeMaximumDimension(List<Position> positions)
	{
		int64 max = 0;

		for (uint32 i = 0; i < positions.Count; i++)
		{
			Position a = positions[i];
			for (uint32 j = i + 1; j < positions.Count; j++)
			{
				Position b = positions[j];
				int64 dim_x = Math.Abs(a.x - b.x) + 1;
				int64 dim_y = Math.Abs(a.y - b.y) + 1;
				int64 dim = dim_x * dim_y;

				if (dim > max)
				{
					max = dim;
				}
			}
		}

		return max;
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		var positions = scope List<Position>();

		for (int32 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];
			StringSplitEnumerator enumerator = line.Split(',');

			Position pos;
			pos.x = uint32.Parse(enumerator.GetNext());
			pos.y = uint32.Parse(enumerator.GetNext());

			positions.Add(pos);
		}

		int64 maximum = ComputeMaximumDimension(positions);

		Console.WriteLine("Maximum is {}", maximum);
	}
}