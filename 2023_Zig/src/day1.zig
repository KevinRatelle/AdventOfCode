const std = @import("std");
const ascii = std.ascii;

const numbers = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

pub fn stringToDigit(line: []u8, index: usize) u8 {
    for (0..numbers.len) |number_index| {
        const number: []const u8 = numbers[number_index];
        var i: usize = index;
        for (0..number.len) |j| {
            if (i >= line.len) {
                break;
            }

            if (line[i] != number[j]) {
                break;
            }

            if (j == (number.len - 1)) {
                return @intCast(number_index + 1);
            }

            i = i + 1;
        }
    }

    return 255;
}

pub fn isDigit(line: []u8, index: usize) bool {
    return stringToDigit(line, index) != 255;
}

pub fn charToDigit(c: u8) u8 {
    const value = switch (c) {
        '0'...'9' => c - '0',
        else => 0,
    };

    return value;
}

pub fn GetFirstDigit(line: []u8, checkString: bool) u32 {
    var first: u8 = 0;

    for (0..line.len) |index| {
        const char: u8 = line[index];
        if (ascii.isDigit(char)) {
            first = charToDigit(char);
            break;
        }

        if (checkString and isDigit(line, index)) {
            first = stringToDigit(line, index);
            break;
        }
    }

    return first;
}

pub fn GetLastDigit(line: []u8, checkString: bool) u32 {
    const size: u32 = @intCast(line.len);
    var last: u8 = 0;

    for (1..(size + 1)) |array_index| {
        const index: usize = size - array_index;
        const char: u8 = line[index];
        if (ascii.isDigit(char)) {
            last = charToDigit(char);
            break;
        }

        if (checkString and isDigit(line, index)) {
            last = stringToDigit(line, index);
            break;
        }
    }

    return last;
}

fn ComputeResultInternal(in_stream: anytype, is_part_b: bool) !void {
    var buf: [1024]u8 = undefined;
    var total: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const first: u32 = GetFirstDigit(line, is_part_b);
        const last: u32 = GetLastDigit(line, is_part_b);
        total += first * 10 + last;
    }

    std.debug.print("Le total est {}.\n", .{total});
}

pub fn ComputeResult(in_stream: anytype, is_part_b: bool) !void {
    try ComputeResultInternal(in_stream, is_part_b);
}
