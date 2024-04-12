program aoc;

uses day1;

const
	file_name = 'day1.txt';

var
	f : TextFile;
	result : longint;

begin
	assign(f, file_name);
	reset(f);

	result := compute_result(f);
	writeln(result)
end.