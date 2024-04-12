package day1

import "core:strings"

compute_sum :: proc(data: string, offset: int) -> (sum: uint)
{
	sum = 0

	for i := 0; i < len(data); i += 1
	{
		next :int = (i+offset) % len(data)
		if (data[i] == data[next])
		{
			sum += uint(data[i]-'0');
		}
	}

	return sum
}
