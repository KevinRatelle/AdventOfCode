
# test in R
myData = read.delim("day1.txt", header = FALSE)

val <- floor(myData/3) - 2

print(sum(val))
