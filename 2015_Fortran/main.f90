
program main
	use Day6

	implicit none
	integer :: io, iocode
	logical :: is_part_b = .false.
	integer, parameter :: max_line_length = 100
	character(len=max_line_length) :: line

	open(newunit=io, file="data/day6.txt")

	read(io, *, iostat=iocode) line

	call compute_solution(io, is_part_b)
	close(io)

	read(*,*)
end program main