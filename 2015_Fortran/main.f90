
program main
	use Day6

	implicit none
	integer :: io, iocode
	logical :: is_part_b = .true.
	integer, parameter :: max_line_length = 100
	character(len=max_line_length) :: line

	open(newunit=io, file="data/day6.txt")

	call compute_solution(io, is_part_b)
	close(io)

	read(*,*)
end program main