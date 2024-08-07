
program main
	use Day5

	implicit none
	integer :: io
	logical :: is_part_b = .true.

	open(newunit=io, file="data/day5.txt")
	call compute_solution(io, is_part_b)
	close(io)

	read(*,*)
end program main