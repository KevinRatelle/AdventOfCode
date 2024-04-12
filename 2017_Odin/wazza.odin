package main

import "core:fmt"
import "core:os"
import "core:strings"

import "day1"

read_file_by_lines_in_whole :: proc(filepath: string)
{
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok
	{
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
	for line in strings.split_lines_iterator(&it)
	{
		//offset :int = 1
		offset :int = len(line)/2
		sum := day1.compute_sum(line, offset)
		fmt.println("Sum is ", sum)
	}
}

main :: proc()
{
	read_file_by_lines_in_whole("day1.txt")
}

