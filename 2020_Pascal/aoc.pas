program aoc;

uses day1;

const
	file_name = 'day1.txt';

var
	f : TextFile;
	result : longint;
	is_part_b : boolean;

begin
	assign(f, file_name);
	reset(f);

	is_part_b := true;
	result := compute_result(f, is_part_b);
	writeln(result)
end.