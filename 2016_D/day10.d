module day10;

import std.conv;
import std.stdio;
import std.string;
import std.algorithm;

struct Output
{
	int m_index;
	bool m_is_bot = false;
}

struct Bot
{
	Output m_low;
	Output m_high;

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

	void set_low(const string type, const int value)
	{
		if (type == "bot")
		{
			m_low.m_is_bot = true;
		}

		m_low.m_index = value;
	}

	void set_high(const string type, const int value)
	{
		if (type == "bot")
		{
			m_high.m_is_bot = true;
		}

		m_high.m_index = value;
	}
}

void resize_if_needed(Bot[]* bots, const int index)
{
	if (bots.length <= index)
	{
		*bots ~= new Bot[index - bots.length + 1];
	}
}

void parse_instruction(Bot[]* bots, string instruction)
{
	auto splitted = instruction.split();

	if (splitted[0] == "value")
	{
		const int bot_index = splitted[5].to!int();
		const int value = splitted[1].to!int();
		resize_if_needed(bots, bot_index);
		(*bots)[bot_index].receive(value);
	}
	else
	{
		int bot_index = splitted[1].to!int();
		int low = splitted[6].to!int();
		int high = splitted[11].to!int();
		resize_if_needed(bots, bot_index);
		(*bots)[bot_index].set_low(splitted[5], low);
		(*bots)[bot_index].set_high(splitted[10], high);
	}
}

void set_output(int[]* output, const int index, const int value)
{
	if (index >= output.length)
	{
		*output ~= new int[index - output.length + 1];
	}

	(*output)[index] = value;
}

Bot[] tick(Bot[] bots, int[]* output)
{
	Bot[] bots_out = bots.dup;

	for(int i = 0; i < bots.length; i++)
	{
		Bot bot = bots[i];
		if (bot.m_vals[0] != -1 && bot.m_vals[1] != -1)
		{
			const int minimum = min(bot.m_vals[0], bot.m_vals[1]);
			if (bot.m_low.m_is_bot)
			{
				bots_out[bot.m_low.m_index].receive(minimum);
			}
			else
			{
				set_output(output, bot.m_low.m_index, minimum);
			}

			const int maximum = max(bot.m_vals[0], bot.m_vals[1]);
			if (bot.m_high.m_is_bot)
			{
				bots_out[bot.m_high.m_index].receive(maximum);
			}
			else
			{
				set_output(output, bot.m_high.m_index, maximum);
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

bool is_done(Bot[] bots)
{
	for(int i = 0; i < bots.length; i++)
	{
		if (!bots[i].contains(-1, -1))
		{
			return false;
		}
	}

	return true;
}

void print_bots(Bot[] bots, int[] output)
{
	writefln("----- printing bots -----");
	for(int i = 0; i < bots.length; i++)
	{
		writefln("Bot %d : Low - %d, high - %d, contains %d and %d", i, bots[i].m_low.m_index, bots[i].m_high.m_index, bots[i].m_vals[0], bots[i].m_vals[1]);
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

	foreach(ref string line; inputs)
	{
		parse_instruction(&bots, line);
	}

	int[] output;
	print_bots(bots, output);

	while (!is_done(bots))
	{
		bots = tick(bots, &output);
	}

	print_bots(bots, output);

	int multiplication = output[0] * output[1] * output[2];

	return multiplication.to!string();
}
