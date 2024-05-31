module day11;

import std.conv;
import std.stdio;
import std.string;
import std.algorithm;
import std.algorithm.sorting;

struct Floor
{
	string[] m_items;

	bool contains(string input)
	{
		foreach(string item; m_items)
		{
			if (item == input)
			{
				return true;
			}
		}

		return false;
	}

	void remove_item(string item)
	{
		string[] items;
		foreach(string str; m_items)
		{
			if (str != item)
			{
				items ~= str.dup;
			}
		}

		m_items = items.dup;
	}

	string remove_at(int index)
	{
		string[] items;
		string removed;

		for(int i = 0; i < m_items.length; i++)
		{
			if (i != index)
			{
				items ~= m_items[i];
			}
			else
			{
				removed = m_items[i];
			}
		}

		m_items = items.dup;

		return removed;
	}

	void add(string item)
	{
		m_items ~= item;
	}
}

Floor parse_floor(string line)
{
	Floor floor;

	auto splitted = line.split();
	for (int i = 0; i < splitted.length; i++)
	{
		string word = splitted[i];
		if (word[$-1] == '.' || word[$-1] == ',')
		{
			word = word[0..$-1];
		}

		if (word == "microchip")
		{
			string n = splitted[i-1][0..2];
			floor.m_items ~= 'm'.to!string() ~ n;
		}

		if (word == "generator")
		{
			string n = splitted[i-1][0..2];
			floor.m_items ~= 'g'.to!string() ~ n;
		}
	}

	return floor;
}

void print_floors(Floor[4] floors)
{
	foreach(Floor floor; floors)
	{
		foreach(string item; floor.m_items)
		{
			writef("%s ", item);
		}

		//writefln(" (%d)", floor.m_items.length);
		writefln("");
	}

	writefln("------");
}

void print_floors(Floor[4][] floors)
{
	writefln("====Floor package====");
	foreach(Floor[4] floor; floors)
	{
		print_floors(floor);
	}
}

Floor[4][] do_all_moves(Floor[4] current)
{
	Floor[4][] output;

	for(int i = 0; i<4; i++)
	{
		if (current[i].contains("e"))
		{
			if (i>0)
			{
				Floor[4] tmp_out = current.dup;
				tmp_out[i].remove_item("e");
				tmp_out[i-1].add("e");

				for(int j = 0; j < tmp_out[i].m_items.length; j++)
				{
					Floor[4] new_out = tmp_out.dup;
					string item = new_out[i].remove_at(j);
					new_out[i-1].add(item);
					output ~= new_out;

					for(int k = 0; k < new_out[i].m_items.length; k++)
					{
						Floor[4] inner_out = new_out.dup;
						string item2 = inner_out[i].remove_at(k);
						inner_out[i-1].add(item2);
						output ~= inner_out;
					}
				}
			}

			if (i<3)
			{
				Floor[4] tmp_out = current.dup;
				tmp_out[i].remove_item("e");
				tmp_out[i+1].add("e");

				for(int j = 0; j < tmp_out[i].m_items.length; j++)
				{
					Floor[4] new_out = tmp_out.dup;
					string item = new_out[i].remove_at(j);
					new_out[i+1].add(item);
					output ~= new_out;

					for(int k = 0; k < new_out[i].m_items.length; k++)
					{
						Floor[4] inner_out = new_out.dup;
						string item2 = inner_out[i].remove_at(k);
						inner_out[i+1].add(item2);
						output ~= inner_out;
					}
				}
			}
		}
	}

	return output;
}

Floor[4][] do_all_moves(Floor[4][] currents)
{
	Floor[4][] potentials;

	for (int i = 0; i < currents.length; i++)
	{
		potentials ~= do_all_moves(currents[i]);
	}

	return potentials;
}

bool is_valid(Floor floor)
{
	for(int i = 0; i < floor.m_items.length; i++)
	{
		if (floor.m_items[i][0] == 'm')
		{
			bool has_wrong_generator = false;
			bool has_good_generator = false;

			for(int j = 0; j < floor.m_items.length; j++)
			{
				if (floor.m_items[j][0] == 'g')
				{
					if (floor.m_items[j][1..2] == floor.m_items[i][1..2])
					{
						has_good_generator = true;
					}
					else
					{
						has_wrong_generator = true;
					}
				}
			}

			if (has_wrong_generator && !has_good_generator)
			{
				return false;
			}
		}
	}

	return true;
}

bool is_valid(Floor[4] current)
{
	foreach(Floor floor; current)
	{
		if (!is_valid(floor))
		{
			return false;
		}
	}

	return true;
}

Floor[4][] remove_invalid(Floor[4][] currents)
{
	Floor[4][] potentials;

	for (int i = 0; i < currents.length; i++)
	{
		if (is_valid(currents[i]))
		{
			potentials ~= currents[i];
		}
	}

	return potentials;
}

bool are_same(Floor a, Floor b)
{
	if (a.m_items.length != b.m_items.length)
	{
		return false;
	}

	for (int i = 0; i < a.m_items.length; i++)
	{
		if (a.m_items[i] != b.m_items[i])
		{
			return false;
		}
	}

	return true;
}

bool are_same(Floor[4] a, Floor[4] b)
{
	for (int i = 0; i < 4; i++)
	{
		if (!are_same(a[i], b[i]))
		{
			return false;
		}
	}

	return true;
}

Floor[4][] remove_duplicates(Floor[4][] currents)
{
	Floor[4][] potentials;

	for (int i = 0; i < currents.length; i++)
	{
		bool has_dupe = false;
		for (int j = i+1; j < currents.length; j++)
		{
			if (are_same(currents[i], currents[j]))
			{
				has_dupe = true;
				break;
			}
		}

		if (!has_dupe)
		{
			potentials ~= currents[i];
		}
	}

	return potentials;
}

bool is_done(Floor[4] current)
{
	return current[0].m_items.length == 0 &&
	       current[1].m_items.length == 0 &&
	       current[2].m_items.length == 0;
}

bool test_all(Floor[4][] currents)
{
	foreach(Floor[4] current; currents)
	{
		if (is_done(current))
		{
			return true;
		}
	}
	return false;
}

Floor sort_items(Floor items)
{
	Floor floor;
	floor.m_items = items.m_items;
	floor.m_items.sort();
	return floor;
}

Floor[4] sort_items(Floor[4] items)
{
	Floor[4] out_floor;

	for(int i = 0; i < items.length; i++)
	{
		Floor sorted = sort_items(items[i]);
		out_floor[i] = sorted;
	}

	return out_floor;
}

Floor[4][] sort_items(Floor[4][] items)
{
	Floor[4][] potentials;

	foreach(Floor[4] current; items)
	{
		Floor[4] sorted = sort_items(current);
		potentials ~= sorted;
	}

	return potentials;
}

string compute_result(string[] inputs)
{
	Floor[4] floors;

	for(int i = 0; i<inputs.length; i++)
	{
		floors[i] = parse_floor(inputs[i]);
	}
	floors[0].m_items ~= "e";

	int count = 0;
	bool is_done = false;

	Floor[4][] potentials;
	potentials ~= floors;

	while (!is_done)
	{
		//writefln("Before");
		//print_floors(potentials);

		potentials = do_all_moves(potentials);

		//writefln("All potentials");
		//print_floors(potentials);

		potentials = remove_invalid(potentials);
		potentials = sort_items(potentials);
		potentials = remove_duplicates(potentials);

		//writefln("All valid");
		//print_floors(potentials);

		is_done = test_all(potentials);
		count++;
		writefln("%d", count);
	}

	return count.to!string();
}
