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
		if (current == -1)
		{
			return pathCount;
		}

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

	static uint64 CountPathsFastInternal(List<Connection> connections, int current, StringView target, Dictionary<int, uint64> dict)
	{
		uint64 pathCount = 0u;
		if (current == -1)
		{
			return pathCount;
		}

		if (dict.ContainsKey(current))
		{
			return dict[current];
		}

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
				pathCount += CountPathsFastInternal(connections, index, target, dict);
			}
		}

		dict[current] = pathCount;

		return pathCount;
	}

	static uint64 CountPathsFast(List<Connection> connections, int current, StringView target)
	{
		var dict = new Dictionary<int, uint64>();
		uint64 pathCount = CountPathsFastInternal(connections, current, target, dict);
		delete dict;

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

		uint64 pathCount = 0;
		if (!isPartB)
		{
			int startIndex = FindInput(connections, "you");
			pathCount = CountPaths(connections, startIndex, "out");
		}
		else
		{
			int svr = FindInput(connections, "svr");
			int fft = FindInput(connections, "fft");
			int dac = FindInput(connections, "dac");

			uint64 dac_fft = CountPathsFast(connections, dac, "fft");
			uint64 svr_dac = CountPathsFast(connections, svr, "dac");
			uint64 fft_out = CountPathsFast(connections, fft, "out");
			pathCount += svr_dac * dac_fft * fft_out;

			uint64 dac_out = CountPathsFast(connections, dac, "out");
			uint64 fft_dac = CountPathsFast(connections, fft, "dac");
			uint64 svr_fft = CountPathsFast(connections, svr, "fft");
			pathCount += svr_fft * fft_dac * dac_out;
		}

		for (Connection connection in connections)
		{
			delete connection.m_outputs;
		}

		Console.WriteLine("Path count is {}", pathCount);
	}
}