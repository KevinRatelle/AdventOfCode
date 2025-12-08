namespace _2025_Beef;

using System;
using System.Collections;

class Day08
{
	struct Position
	{
		public double x;
		public double y;
		public double z;
	}

	struct Connection
	{
		public uint32 a;
		public uint32 b;
	}

	static double Distance(Position a, Position b)
	{
		double x = a.x - b.x;
		double y = a.y - b.y;
		double z = a.z - b.z;

		return Math.Sqrt(x * x + y * y + z * z);
	}

	static void GenerateConnections(List<Position> positions, List<Connection> connections, uint32 connectionCount)
	{
		while (connections.Count < connectionCount)
		{
			double minimum = double.MaxValue;
			Connection min;
			min.a = 0;
			min.b = 0;

			for (uint32 i = 0; i < positions.Count; i++)
			{
				for (uint32 j = i + 1; j < positions.Count; j++)
				{
					if (Distance(positions[i], positions[j]) < minimum)
					{
						Connection c;
						c.a = i;
						c.b = j;

						if (!connections.Contains(c))
						{
							minimum = Distance(positions[i], positions[j]);
							min = c;
						}
					}
				}
			}

			if (min.a != 0 || min.b != 0)
			{
				connections.Add(min);
			}
		}
	}

	static void GenerateIsland(ref List<uint32> positions, List<Connection> connections, ref List<uint32> island)
	{
		island.Add(positions[positions.Count - 1]);
		positions.Resize(positions.Count - 1);

		uint32 index = 0;
		while (index < island.Count)
		{
			for (let connection in connections)
			{
				if (connection.a == island[index])
				{
					if (!island.Contains(connection.b))
					{
						island.Add(connection.b);
						positions.Remove(connection.b);
					}
				}

				if (connection.b == island[index])
				{
					if (!island.Contains(connection.a))
					{
						island.Add(connection.a);
						positions.Remove(connection.a);
					}
				}
			}

			index++;
		}
	}

	static void GenerateCircuits(uint32 count, List<Connection> connections, ref uint32[] largest)
	{
		var positions = scope List<uint32>();
		for (uint32 i = 0; i < count; i++)
		{
			positions.Add(i);
		}

		while (!positions.IsEmpty)
		{
			var island = scope List<uint32>();
			GenerateIsland(ref positions, connections, ref island);

			if (island.Count > largest[2])
			{
				if (island.Count > largest[1])
				{
					largest[2] = largest[1];

					if (island.Count > largest[0])
					{
						largest[1] = largest[0];
						largest[0] = (uint32)island.Count;
					}
					else
					{
						largest[1] = (uint32)island.Count;
					}
				}
				else
				{
					largest[2] = (uint32)island.Count;
				}
			}
		}
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		var positions = scope List<Position>();

		for (int32 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];

			Position pos;

			StringSplitEnumerator enumerator = line.Split(',');
			StringView x = enumerator.GetNext();
			pos.x = double.Parse(x);

			StringView y = enumerator.GetNext();
			pos.y = double.Parse(y);

			StringView z = enumerator.GetNext();
			pos.z = double.Parse(z);

			positions.Add(pos);
		}

		var connections = scope List<Connection>();
		GenerateConnections(positions, connections, 1000);

		var largest = scope uint32[3];
		GenerateCircuits((uint32)positions.Count, connections, ref largest);

		uint32 count = largest[0] * largest[1] * largest[2];

		Console.WriteLine("Count is {}", count);
	}
}