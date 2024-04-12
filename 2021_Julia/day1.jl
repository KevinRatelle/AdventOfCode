module day1

export compute_result

function compute_result(f)
	count = 0
	previous = typemax(UInt32)

	# read till end of file
	while ! eof(f)
		s = readline(f)
		current = parse(UInt32, s)

		if (current > previous)
			count = count + 1
		end

		previous = current
	end

	return count
end

end