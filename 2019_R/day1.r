
compute_result <- function(myData, is_part_b)
{
	for (x in myData)
	{
		val <- floor(x/3) - 2
		if (is_part_b)
		{
			remain <- val
			while (any(remain > 0))
			{
				remain <- floor(remain/3) - 2
				val <- val + pmax(remain, 0)
			}
		}
	}

	
	return (sum(val))
}

