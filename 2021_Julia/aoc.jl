include("day1.jl")
using .day1

println("hello world")

count = 0

open("day1.txt", "r") do f
	is_part_b = true
	global count = compute_result(f, is_part_b)
end

println("$count")
