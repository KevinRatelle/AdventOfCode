include("day1.jl")
using .day1

println("hello world")

count = 0

open("day1.txt", "r") do f
	global count = compute_result(f)
end

println("$count")
