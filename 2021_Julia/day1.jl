module day1

export compute_result

function compute_result(f, is_part_b)
	values = Vector{UInt32}()

	# read till end of file
	while !eof(f)
		s = readline(f)
		current = parse(UInt32, s)
		push!(values, current)
	end

	count = 0
	previous = typemax(UInt32)

	group_size = 1

	if (is_part_b)
		group_size = 3
	end

	for i in group_size:length(values)
		val = values[i]
		for j in 1:group_size-1
			val = val + values[i-j]
		end

		if (val > previous)
			count = count + 1
		end

		previous = val
	end

	return count
end

end