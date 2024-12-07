const std = @import("std");
const assert = std.debug.assert;
const ascii = std.ascii;

const MapKey = struct { m_row: u16, m_column: u16 };
const Part = struct { m_value: u32, m_length: u16 };
const Gear = struct { m_value: u32, m_neighbors: u8 };

pub fn charToDigit(c: u8) u8 {
    const value = switch (c) {
        '0'...'9' => c - '0',
        else => 0,
    };
    return value;
}

pub fn AppendDictionaries(comptime T: type, line_index: u16, line: []const u8, symbol_map: *std.AutoHashMap(MapKey, T), parts_map: *std.AutoHashMap(MapKey, Part)) !void {
    var index: u16 = 0;
    while (index < line.len) {
        var char: u8 = line[index];
        if (char == '.') {
            index += 1;
            continue;
        }

        // is a symbol
        const column: u16 = @intCast(index);
        if (!ascii.isDigit(char)) {
            if (T == u8) {
                try symbol_map.put(MapKey{ .m_row = line_index, .m_column = column }, char);
            } else {
                if (char == '*') {
                    try symbol_map.put(MapKey{ .m_row = line_index, .m_column = column }, Gear{ .m_value = 1, .m_neighbors = 0 });
                }
            }
            index += 1;
            continue;
        }

        var part_number: u32 = 0;
        const mapKey = MapKey{ .m_row = line_index, .m_column = column };

        // is a part number
        while (index < line.len) {
            char = line[index];
            if (!ascii.isDigit(char)) {
                break;
            }
            part_number *= 10;
            part_number += charToDigit(char);
            index += 1;
        }

        const length: u16 = index - mapKey.m_column;
        try parts_map.put(mapKey, Part{ .m_value = part_number, .m_length = length });
    }
}

pub fn ComputeResult(in_stream: anytype, comptime is_part_b: bool) !void {
    var buf: [1024]u8 = undefined;
    const symbol_type = if (is_part_b) Gear else u8;
    var symbol_map = std.AutoHashMap(MapKey, symbol_type).init(std.heap.page_allocator);
    defer symbol_map.deinit();

    var parts_map = std.AutoHashMap(MapKey, Part).init(std.heap.page_allocator);
    defer parts_map.deinit();

    var total: u64 = 0;
    var line_index: u16 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (is_part_b) {
            try AppendDictionaries(Gear, line_index, line, &symbol_map, &parts_map);
        } else {
            try AppendDictionaries(u8, line_index, line, &symbol_map, &parts_map);
        }
        line_index += 1;
    }

    var keyIt = parts_map.keyIterator();
    while (keyIt.next()) |key| {
        const part = parts_map.get(key.*).?;

        const row: u16 = key.m_row;
        const col: u16 = key.m_column;
        const length: u16 = part.m_length;
        const value: u32 = part.m_value;

        const left_col = if (col == 0) 0 else col - 1;
        const right_col = col + length;
        const top_row = if (row == 0) 0 else row - 1;
        const bottom_row = row + 1;

        var found_symbol: bool = false;
        for (top_row..bottom_row + 1) |row_tested| {
            const current_row: u16 = @intCast(row_tested);

            for (left_col..right_col + 1) |col_tested| {
                const current_col: u16 = @intCast(col_tested);
                const contains_key: bool = symbol_map.contains(MapKey{ .m_row = current_row, .m_column = current_col });
                if (contains_key) {
                    if (!is_part_b) {
                        found_symbol = true;
                        break;
                    } else {
                        const symbol: *Gear = symbol_map.getPtr(MapKey{ .m_row = current_row, .m_column = current_col }).?;
                        symbol.*.m_value *= value;
                        symbol.*.m_neighbors += 1;
                    }
                }
            }

            if (found_symbol) {
                break;
            }
        }

        if (found_symbol) {
            total += value;
        }
    }

    if (is_part_b) {
        var symbolIt = symbol_map.valueIterator();
        while (symbolIt.next()) |gear| {
            if (gear.*.m_neighbors == 2) {
                total += gear.*.m_value;
            }
        }
    }

    std.debug.print("Le total est {}.\n", .{total});
}
