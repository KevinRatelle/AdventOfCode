import os

import day1

fn main()
{
    lines := os.read_lines('day1.txt')!
    total := day1.compute_result(lines)


    println('Hello, ${total} !')
}