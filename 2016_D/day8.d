module day8;

import std.conv;
import std.stdio;
import std.array;

class Grid
{
	bool[50][6] m_data;

	this()
	{
		foreach(bool[] row; m_data)
		{
			foreach(ref bool item; row)
			{
				item = false;
			}
		}
	}

	void set(const int j, const int i, const bool value)
	{
		m_data[j][i] = value;
	}

	int count() const
	{
		int output;
		foreach(const bool[] row; m_data)
		{
			foreach(bool item; row)
			{
				if (item)
				{
					output++;
				}
			}
		}

		return output;
	}


	void print_grid() const
	{
		writefln("Printing grid");

		foreach(const bool[] row; m_data)
		{
			foreach(bool item; row)
			{
				if (item)
				{
					writef("#");
				}
				else
				{
					writef(".");
				}
			}

			writefln("");
		}
	}

	void rotate_col(int col, int count)
	{
		bool[] init = new bool[m_data.length];
		for (int i = 0; i < m_data.length; i++)
		{
			init[i] = m_data[i][col];
		}

		for (int i = 0; i < m_data.length; i++)
		{
			const int index = (i+count) % m_data.length;
			m_data[index][col] = init[i];
		}
	}

	void rotate_row(int row, int count)
	{
		bool[] init = m_data[row].dup;

		for (int i = 0; i <  m_data[row].length; i++)
		{
			const int index = (i+count) % m_data[row].length;
			m_data[row][index] = init[i];
		}
	}
}

void ProcessCommand(string[] command, Grid* grid)
{
	if (command[0] == "rect")
	{
		string[] dims_str = command[1].split('x');
		const int x_dim = dims_str[0].to!int();
		const int y_dim = dims_str[1].to!int();

		for (int j = 0; j < y_dim; j++)
		{
			for(int i = 0; i < x_dim; i++)
			{
				grid.set(j, i, true);
			}
		}
	}

	if (command[0] == "rotate")
	{
		if (command[1] == "column")
		{
			assert(command[2][0] == 'x');
			const string col_str = command[2].split('=')[1];
			const int col = col_str.to!int();
			const int count = command[4].to!int();
			grid.rotate_col(col, count);
		}

		if (command[1] == "row")
		{
			assert(command[2][0] == 'y');
			const string row_str = command[2].split('=')[1];
			const int row = row_str.to!int();
			const int count = command[4].to!int();
			grid.rotate_row(row, count);
		}
	}
}

string compute_result(string[] inputs)
{
	Grid grid = new Grid();
	grid.print_grid();

	foreach(ref string line; inputs)
	{
		auto splitted = line.split();
		ProcessCommand(splitted, &grid);
	}

	grid.print_grid();

	return grid.count().to!string();
}
