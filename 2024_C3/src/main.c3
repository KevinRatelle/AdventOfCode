module m_2024_c3;

import std::io;
import std::collections::list;
import std::time;

import day1;
import day2;
import day3;
import day4;
import day5;
import day6;
import day7;
import day8;
import day9;
import day10;
import day11;
import day12;
import day13;
import day14;
import day15;
import day16;
import day17;
import day18;
import day19;
import day20;
import day21;
import day22;
import day23;
import day24;
import day25;

fn void process(int day, String data, bool is_part_b, bool verbose)
{
	switch(day)
	{
		case 1:
		{
			io::printfn("Expected : %s", is_part_b ? "22776016": "1660292");
			day1::process(data, is_part_b, verbose);
		}
		case 2:
		{
			io::printfn("Expected : %s", is_part_b ? "566": "526");
			day2::process(data, is_part_b, verbose);
		}
		case 3:
		{
			io::printfn("Expected : %s", is_part_b ? "111762583": "169021493");
			day3::process(data, is_part_b, verbose);
		}
		case 4:
		{
			io::printfn("Expected : %s", is_part_b ? "1965": "2603");
			day4::process(data, is_part_b, verbose);
		}
		case 5:
		{
			io::printfn("Expected : %s", is_part_b ? "4598": "5452");
			day5::process(data, is_part_b, verbose);
		}
		case 6:
		{
			io::printfn("Expected : %s", is_part_b ? "1984": "5404");
			day6::process(data, is_part_b, verbose);
		}
		case 7:
		{
			io::printfn("Expected : %s", is_part_b ? "149956401519484": "12839601725877");
			day7::process(data, is_part_b, verbose);
		}
		case 8:
		{
			io::printfn("Expected : %s", is_part_b ? "1157": "320");
			day8::process(data, is_part_b, verbose);
		}
		case 9:
		{
			io::printfn("Expected : %s", is_part_b ? "6237075041489": "6216544403458");
			day9::process(data, is_part_b, verbose);
		}
		case 10:
		{
			io::printfn("Expected : %s", is_part_b ? "1238": "574");
			day10::process(data, is_part_b, verbose);
		}
		case 11:
		{
			io::printfn("Expected : %s", is_part_b ? "218279375708592": "183435");
			day11::process(data, is_part_b, verbose);
		}
		case 12:
		{
			io::printfn("Expected : %s", is_part_b ? "844132": "1396562");
			day12::process(data, is_part_b, verbose);
		}
		case 13:
		{
			io::printfn("Expected : %s", is_part_b ? "107824497933339": "26299");
			day13::process(data, is_part_b, verbose);
		}
		case 14:
		{
			io::printfn("Expected : %s", is_part_b ? "6493": "228457125");
			day14::process(data, is_part_b, verbose);
		}
		case 15:
		{
			io::printfn("Expected : %s", is_part_b ? "1376686": "1349898");
			day15::process(data, is_part_b, verbose);
		}
		case 16:
		{
			io::printfn("Expected : %s", is_part_b ? "520": "122492");
			day16::process(data, is_part_b, verbose);
		}
		case 17:
		{
			io::printfn("Expected : %s", is_part_b ? "164278496489149": "3,6,7,0,5,7,3,1,4");
			day17::process(data, is_part_b, verbose);
		}
		case 18:
		{
			io::printfn("Expected : %s", is_part_b ? "45,16": "408");
			day18::process(data, is_part_b, verbose);
		}
		case 19:
		{
			io::printfn("Expected : %s", is_part_b ? "603191454138773": "216");
			day19::process(data, is_part_b, verbose);
		}
		case 20:
		{
			io::printfn("Expected : %s", is_part_b ? "983905": "1323");
			day20::process(data, is_part_b, verbose);
		}
		case 21:
		{
			io::printfn("Expected : %s", is_part_b ? "170279148659464": "137870");
			day21::process(data, is_part_b, verbose);
		}
		case 22:
		{
			io::printfn("Expected : %s", is_part_b ? "1568": "14082561342");
			day22::process(data, is_part_b, verbose);
		}
		case 23:
		{
			io::printfn("Expected : %s", is_part_b ? "ar,ep,ih,ju,jx,le,ol,pk,pm,pp,xf,yu,zg": "1098");
			day23::process(data, is_part_b, verbose);
		}
		case 24:
		{
			io::printfn("Expected : %s", is_part_b ? "cpm,ghp,gpr,krs,nks,z10,z21,z33": "51107420031718");
			day24::process(data, is_part_b, verbose);
		}
		case 25:
		{
			io::printfn("Expected : %s", is_part_b ? "no part B": "2691");
			day25::process(data, is_part_b, verbose);
		}
	}
}

fn int main(String[] args)
{
	io::printfn("#################################");
	io::printfn("##      Advent of Code 2024    ##");
	io::printfn("#################################\n");

	bool verbose = false;

	for (int i = 1; i < 26; i++)
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
		long ms = elapsed.to_ms();
		if (ms > 10000)
		{
			io::printfn("Elapsed: %d s\n", ms / 1000);
		}
		else
		{
			io::printfn("Elapsed: %d ms\n", ms);
		}

	}

	return 0;
}
