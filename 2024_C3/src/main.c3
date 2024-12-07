module m_2024_c3;
import std::io;
import std::collections::list;
import day7;

fn int main(String[] args)
{
	io::printn("Hello, World!");

	String file_name = "resources/day7.txt";
	String! data = (String) io::file::load_new(file_name);
	if (catch error = data)
	{
		return 1;
	}
	defer free(data);

	bool is_part_b = false;
	day7::process(data, is_part_b);

	return 0;
}
