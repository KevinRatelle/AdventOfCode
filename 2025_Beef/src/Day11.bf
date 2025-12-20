namespace _2025_Beef;

using System;
using System.Collections;

class Day11
{
	struct Connection
	{
		public StringView m_input;
		public List<StringView> m_outputs;
	}

	static int FindInput(List<Connection> connections, StringView input)
	{
		for (int i = 0; i < connections.Count; i++)
		{
			if (connections[i].m_input == input)
			{
				return i;
			}
		}

		return -1;
	}

	static uint32 CountPaths(List<Connection> connections, int current, StringView target)
	{
		uint32 pathCount = 0u;

		Connection connection = connections[current];
		for (var child in connection.m_outputs)
		{
			if (child == target)
			{
				pathCount++;
			}
			else
			{
				int index = FindInput(connections, child);
				pathCount += CountPaths(connections, index, target);
			}
		}

		return pathCount;
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		var connections = scope List<Connection>();

		for (int32 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];

			var connection = Connection();
			connection.m_input = line[0 ... 2];
			connection.m_outputs = new List<StringView>();

			StringSplitEnumerator enumerator = line[5 ... line.Length - 1].Split(' ');
			while (enumerator.GetNext() case .Ok(let item))
			{
				connection.m_outputs.Add(item);
			}

			connections.Add(connection);
		}

		int startIndex = FindInput(connections, "you");
		uint32 pathCount = CountPaths(connections, startIndex, "out");

		for (Connection connection in connections)
		{
			delete connection.m_outputs;
		}

		Console.WriteLine("Path count is {}", pathCount);
	}
}