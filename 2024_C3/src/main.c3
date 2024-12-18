module m_2024_c3;

import std::io;
import std::collections::list;
import std::time;

import day17;

fn int main(String[] args)
{
	io::printn("Hello, World!");

	String file_name = "resources/day17.txt";
	String! data = (String) io::file::load_new(file_name);
	if (catch error = data)
	{
		return 1;
	}
	defer free(file_name);
	defer free(data);

	Time start = time::now();
	bool is_part_b = true;
	day17::process(data, is_part_b);

	Duration elapsed = time::now().diff_us(start);
	io::printfn("Elapsed: %d ms", elapsed.to_ms());

	return 0;
}
