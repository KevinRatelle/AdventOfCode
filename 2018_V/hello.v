import os

fn main()
{
    lines := os.read_lines('day1.txt')!

    mut total := int(0)
    for line in lines
    {
        mut mult := int(1)
        first_char := line[0]
        if first_char == `-`
        {
            mult = -1
        }

        value := line[1..line.len].u32()

        println('${line} : ${value}')

        total += (mult * value)
    }

    println('Hello, ${total} !')
}