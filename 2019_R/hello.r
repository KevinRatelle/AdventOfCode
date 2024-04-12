
# test in R

source("day1.r")

myData = read.delim("day1.txt", header = FALSE)

is_part_b = TRUE
res =compute_result(myData, is_part_b)

print(res)
