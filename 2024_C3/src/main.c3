module m_2024_c3;
import std::io;
import std::collections::list;
import day2;

fn int main(String[] args)
{
	io::printn("Hello, World!");

	String file_name = "resources/day2.txt";
	String! data = (String) io::file::load_new(file_name);
	if (catch error = data)
	{
		return 1;
	}
	defer free(data);

	String[] lines = data.split("\r\n");
	defer free(lines);

	bool is_part_b = false;
	day2::process(lines, is_part_b);

	return 0;
}
