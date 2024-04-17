module day10;

import std.conv;
import std.stdio;
import std.string;
import std.algorithm;

struct Bot
{
	bool m_low_to_bot;
	int m_low;

	bool m_high_to_bot;
	int m_high;
	int[2] m_vals = [-1, -1];

	void receive(int val)
	{
		if (m_vals[0] == -1)
		{
			m_vals[0] = val;
		}
		else
		{
			m_vals[1] = val;
		}
	}

	bool contains(const int val)
	{
		return m_vals[0] == val || m_vals[1] == val;
	}

	bool contains(const int a, const int b)
	{
		return contains(a) && contains(b);
	}
}

Bot[] parse_instruction(Bot[] bots, string instruction)
{
	auto splitted = instruction.split();

	if (splitted[0] == "value")
	{
		int bot_index = splitted[5].to!int();
		int value = splitted[1].to!int();

		if (bots.length <= bot_index)
		{
			bots ~= new Bot[bot_index - bots.length + 1];
		}

		bots[bot_index].receive(value);
	}
	else
	{
		int bot_index = splitted[1].to!int();
		int low = splitted[6].to!int();
		int high = splitted[11].to!int();

		if (bots.length <= bot_index)
		{
			bots ~= new Bot[bot_index - bots.length + 1];
		}

		bots[bot_index].m_low = low;
		bots[bot_index].m_high = high;

		if (splitted[5] == "bot")
		{
			bots[bot_index].m_low_to_bot = true;
		}
		else
		{
			bots[bot_index].m_low_to_bot = false;
		}

		if (splitted[10] == "bot")
		{
			bots[bot_index].m_high_to_bot = true;
		}
		else
		{
			bots[bot_index].m_high_to_bot = false;
		}
	}

	return bots;
}

Bot[] tick(Bot[] bots)
{
	Bot[] bots_out = bots.dup;

	for(int i = 0; i < bots.length; i++)
	{
		Bot bot = bots[i];
		if (bot.m_vals[0] != -1 && bot.m_vals[1] != -1)
		{
			if (bot.m_low_to_bot)
			{
				bots_out[bot.m_low].receive(min(bot.m_vals[0], bot.m_vals[1]));
			}
			else
			{

			}

			if (bot.m_high_to_bot)
			{
				bots_out[bot.m_high].receive(max(bot.m_vals[0], bot.m_vals[1]));
			}
			else
			{

			}

			bots_out[i].m_vals[0] = -1;
			bots_out[i].m_vals[1] = -1;
		}
	}

	return bots_out;
}

int search_bots(Bot[] bots)
{
	for(int i = 0; i < bots.length; i++)
	{
		if (bots[i].contains(61, 17))
		{
			return i;
		}
	}

	return -1;
}

void print_bots(Bot[] bots, int[] output)
{
	writefln("----- printing bots -----");
	for(int i = 0; i < bots.length; i++)
	{
		writefln("Bot %d : Low - %d, high - %d, contains %d and %d", i, bots[i].m_low, bots[i].m_high, bots[i].m_vals[0], bots[i].m_vals[1]);
	}

	foreach(int o; output)
	{
		writef("%d ,", o);
	}

	writefln("");
}

string compute_result(string[] inputs)
{
	Bot[] bots;
	int[] output;

	foreach(ref string line; inputs)
	{
		bots = parse_instruction(bots, line);
	}

	print_bots(bots, output);

	int bot_index = -1;
	while (bot_index == -1)
	{
		bot_index = search_bots(bots);
		bots = tick(bots);
		print_bots(bots, output);
	}

	return bot_index.to!string();
}
