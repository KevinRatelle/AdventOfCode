const std = @import("std");
const day = @import("day2.zig");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./data/Day2.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();

    const start = std.time.nanoTimestamp();
    const is_part_b = false;
    try day.ComputeResult(in_stream, is_part_b);
    const end = std.time.nanoTimestamp();

    const elapsed = @divTrunc((end - start), 1000000);
    std.debug.print("All done in {d} millis!\n", .{elapsed});
}
