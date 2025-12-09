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

	struct Connection : IHashable
	{
		public uint32 a;
		public uint32 b;

		public this
		{
			a = 0;
			b = 0;
		}

		public int GetHashCode()
		{
			return ((int)a << 32) + b;
		}
	}

	static double DistanceSquared(Position a, Position b)
	{
		double x = a.x - b.x;
		double y = a.y - b.y;
		double z = a.z - b.z;

		return x * x + y * y + z * z;
	}

	static void GenerateConnections(List<Position> positions, List<Connection> connectionsOut, uint32 connectionCount)
	{
		// generate the X smallest connections

		Console.WriteLine("Generating connections.");

		var connections = scope HashSet<Connection>();

		while (connections.Count < connectionCount)
		{
			if ((connections.Count % 500) == 0)
			{
				Console.WriteLine("  - Generated {} connections of {}.", connections.Count, connectionCount);
			}

			double minimum = double.MaxValue;
			Connection min;
			min.a = 0;
			min.b = 0;

			for (uint32 i = 0; i < positions.Count; i++)
			{
				for (uint32 j = i + 1; j < positions.Count; j++)
				{
					if (DistanceSquared(positions[i], positions[j]) < minimum)
					{
						Connection c;
						c.a = i;
						c.b = j;

						if (!connections.Contains(c))
						{
							minimum = DistanceSquared(positions[i], positions[j]);
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

		for (Connection connection in connections)
		{
			connectionsOut.Add(connection);
		}
	}

	static void MergeIslands(ref List<List<uint32>> islands, int i, int j)
	{
		for (int k = 0; k < islands[j].Count; k++)
		{
			islands[i].Add(islands[j][k]);
		}

		delete islands[j];
		islands.RemoveAt(j);
	}

	static void ProcessConnection(ref List<List<uint32>> islands, Connection connection)
	{
		for (int islandIndex = islands.Count - 1; islandIndex >= 0; islandIndex--)
		{
			List<uint32> island = islands[islandIndex];

			if (island.Contains(connection.a) && island.Contains(connection.b))
			{
				// do nothing
			}
			else if (island.Contains(connection.a))
			{
				for (int i = 0; i < islandIndex; i++)
				{
					if (islands[i].Contains(connection.b))
					{
						MergeIslands(ref islands, i, islandIndex);
					}
				}
			}
			else if (island.Contains(connection.b))
			{
				for (int i = 0; i < islandIndex; i++)
				{
					if (islands[i].Contains(connection.a))
					{
						MergeIslands(ref islands, i, islandIndex);
					}
				}
			}
		}
	}

	static Connection ProcessConnections(ref List<List<uint32>> islands, List<Connection> connections)
	{
		for (uint32 i = 0; i < connections.Count; i++)
		{
			Connection connection = connections[i];
			ProcessConnection(ref islands, connection);

			if (islands.Count == 1)
			{
				return connection;
			}
		}

		return Connection();
	}

	static Connection ProcessConnections(ref List<List<uint32>> islands, List<Position> positions, uint32 count)
	{
		var connections = scope List<Connection>();
		GenerateConnections(positions, connections, count);

		return ProcessConnections(ref islands, connections);
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

		// prepare all islands, 1 item per island
		var islands = new List<List<uint32>>();
		for (uint32 i = 0; i < positions.Count; i++)
		{
			var island = new List<uint32>();
			island.Add(i);
			islands.Add(island);
		}

		if (!isPartB)
		{
			ProcessConnections(ref islands, positions, 1000);

			var largest = scope uint32[3];
			for (int i = 0; i < 3; i++)
			{
				uint32 max = 0;
				for (uint32 j = 0; j < islands.Count; j++)
				{
					if (islands[j].Count > islands[max].Count)
					{
						max = j;
					}
				}

				largest[i] = (uint32)islands[max].Count;

				delete islands[max];
				islands.RemoveAt(max);
			}

			uint32 count = largest[0] * largest[1] * largest[2];
			Console.WriteLine("Count is {}", count);
		}
		else
		{
			// assume 10 000 is big enough
			Connection c = ProcessConnections(ref islands, positions, 10000);
			Console.WriteLine("Count is {}", (uint32)positions[c.a].x * (uint32)positions[c.b].x);
		}

		for (var island in islands)
		{
			delete island;
		}
		delete islands;
	}
}