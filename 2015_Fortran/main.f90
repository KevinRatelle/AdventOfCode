
include "day1.f90"

program main
	use Day2

	implicit none
	integer :: io
	logical :: is_part_b = .false.

	open(newunit=io, file="day2.txt")
	call compute_solution(io, is_part_b)
	close(io)

	read(*,*)
end program main