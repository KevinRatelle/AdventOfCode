
program main
	use Day3

	implicit none
	integer :: io
	logical :: is_part_b = .false.

	open(newunit=io, file="data/day3.txt")
	call compute_solution(io, is_part_b)
	close(io)

	read(*,*)
end program main