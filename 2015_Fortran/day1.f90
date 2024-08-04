
include "core.f90"

module Day1
	use Core

	implicit none

	contains
		subroutine compute_solution(io, is_part_b)
			implicit none

			logical, intent(in) :: is_part_b
			integer, intent(in) :: io

			character(len=:), allocatable :: line
			integer :: count = 0, index = 0, iostat = 0

			! read line
			call get_line(io, line, iostat)

			do index = 1, line.len
				if (line(index:index) == '(') then
					count = count + 1
				else if (line(index:index) == ')') then
					count = count - 1
				end if

				if (is_part_b .and. count == -1) then
					write(*,*) index
					exit
				end if
			end do

			if (.not. is_part_b) then
				write(*,*) count
			end if
		end subroutine compute_solution
end module Day1