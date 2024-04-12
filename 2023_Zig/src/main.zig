
const std = @import("std");
const day = @import("day1.zig");

pub fn main() !void
{
	std.debug.print("Salut ma belle {s}.\n", .{"Dapne"});

	var file = try std.fs.cwd().openFile("./data/Day1.txt", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	const in_stream = buf_reader.reader();

	const start = std.time.nanoTimestamp();
	try day.ComputeResult_PartB(in_stream);
	const end = std.time.nanoTimestamp();

	const elapsed = @divTrunc((end - start), 1000000);
	std.debug.print("All done in {d} millis!\n", .{elapsed});
}