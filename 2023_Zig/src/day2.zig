const std = @import("std");
const assert = std.debug.assert;

const Counts = struct { m_red: u8, m_blue: u8, m_green: u8 };
const Color = enum { Blue, Red, Green };

pub fn GetColor(color: []const u8) Color {
    if (std.mem.eql(u8, color, "green")) {
        return Color.Green;
    }

    if (std.mem.eql(u8, color, "red")) {
        return Color.Red;
    }

    if (std.mem.eql(u8, color, "blue")) {
        return Color.Blue;
    }

    return Color.Blue;
}

pub fn GetCounts(colors: []const u8) Counts {
    var it = std.mem.splitSequence(u8, colors, ", ");
    var counts = Counts{ .m_blue = 0, .m_green = 0, .m_red = 0 };
    while (it.next()) |color_string| {
        var it2 = std.mem.splitSequence(u8, color_string, " ");

        const count_string = it2.next().?;
        const count = std.fmt.parseInt(u8, count_string, 10) catch unreachable;

        const color_name = it2.next().?;
        const color: Color = GetColor(color_name);

        switch (color) {
            .Blue => counts.m_blue = count,
            .Red => counts.m_red = count,
            .Green => counts.m_green = count,
        }
    }
    return counts;
}

pub fn GetMaxCounts(grabs: []const u8) Counts {
    var it = std.mem.splitSequence(u8, grabs, "; ");
    var max_counts = Counts{ .m_blue = 0, .m_green = 0, .m_red = 0 };

    while (it.next()) |colors| {
        const counts: Counts = GetCounts(colors);

        if (counts.m_blue > max_counts.m_blue) {
            max_counts.m_blue = counts.m_blue;
        }

        if (counts.m_green > max_counts.m_green) {
            max_counts.m_green = counts.m_green;
        }

        if (counts.m_red > max_counts.m_red) {
            max_counts.m_red = counts.m_red;
        }
    }
    return max_counts;
}

pub fn GetIdentifierIfValid(line: []const u8) !u32 {
    var it = std.mem.splitSequence(u8, line, ": ");
    const first_half: []const u8 = it.next().?;

    var it2 = std.mem.splitSequence(u8, first_half, " ");
    const game_string = it2.next().?;
    assert(std.mem.eql(u8, game_string, "Game"));
    const game_number_string: []const u8 = it2.next().?;
    const game_number = std.fmt.parseInt(u32, game_number_string, 10);

    const second_half: []const u8 = it.next().?;
    const counts = GetMaxCounts(second_half);

    if (counts.m_red > 12) {
        return 0;
    }

    if (counts.m_green > 13) {
        return 0;
    }

    if (counts.m_blue > 14) {
        return 0;
    }

    return game_number;
}

fn GetGamePower(line: []const u8) u32 {
    var it = std.mem.splitSequence(u8, line, ": ");
    const first_half: []const u8 = it.next().?;

    assert(first_half.len > 0);

    const second_half: []const u8 = it.next().?;
    const counts = GetMaxCounts(second_half);

    const blue: u32 = @intCast(counts.m_blue);
    const green: u32 = @intCast(counts.m_green);
    const red: u32 = @intCast(counts.m_red);

    return blue * green * red;
}

pub fn ComputeResult(in_stream: anytype, is_part_b: bool) !void {
    var buf: [1024]u8 = undefined;
    var total: u32 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (is_part_b) {
            std.debug.print("Power {}\n", .{GetGamePower(line)});
            total += GetGamePower(line);
        } else {
            total += try GetIdentifierIfValid(line);
        }
    }

    std.debug.print("Le total est {}.\n", .{total});
}
