import hashlib

original_string = "bgvyzdsv" # my puzzle input
is_part_b = True

target = "000000"
count = 5
if is_part_b:
    count = 6

number = 0
while True:
	number += 1

	test_string = original_string + str(number)
	result = hashlib.md5(test_string.encode())
	result_string = result.hexdigest()

	if result_string[0:count] == target[0:count]:
		break

print(number)