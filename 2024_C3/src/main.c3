module m_2024_c3;

import std::io;
import std::collections::list;
import std::time;

import day1;
import day2;

fn void process(int day, String data, bool is_part_b, bool verbose)
{
	switch(day)
	{
		case 1:
		{
			day1::process(data, is_part_b, verbose);
		}
		case 2:
		{
			day2::process(data, is_part_b, verbose);
		}
	}
}

fn int main(String[] args)
{
	io::printfn("#################################");
	io::printfn("##      Advent of Code 2024    ##");
	io::printfn("#################################\n");

	bool verbose = false;

	for (int i = 1; i < 3; i++)
	{	
		io::printfn("---------------------------------");
		io::printfn("------------ DAY %d -------------", i);
		io::printfn("---------------------------------");

		char[20] buffer;
		String! file_name = (String) io::bprintf(&buffer, "resources/day%d.txt", i);
		if (catch err = file_name)
		{
			return 1;
		}

		String! data = (String) io::file::load_new(file_name);
		if (catch error = data)
		{
			return 1;
		}
		defer free(data);

		Time start = time::now();

		io::printfn("***** Part A *****");
		process(i, data, false, verbose);

		io::printfn("***** Part B *****");
		process(i, data, true, verbose);

		Duration elapsed = time::now().diff_us(start);
		io::printfn("Elapsed: %d ms\n", elapsed.to_ms());
	}

	return 0;
}
