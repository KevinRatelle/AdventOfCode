module day1

import arrays

pub fn compute_result(lines []string) int
{
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
        total += (mult * value)
    }

    return total
}

pub fn compute_result_part_b(lines []string) int
{
    mut arr := []int{}
    mut total := int(0)

    for
    {
        mut found := false

        for line in lines
        {
            arr = arrays.concat(arr, total)

            mut mult := int(1)
            first_char := line[0]
            if first_char == `-`
            {
                mult = -1
            }

            value := line[1..line.len].int()
            total += (mult * value)

            for v in arr
            {
                if total == v
                {
                    found = true
                }
            }

            if found
            {
                break
            }
        }

        if found
        {
            break
        }
    }

    return total
}