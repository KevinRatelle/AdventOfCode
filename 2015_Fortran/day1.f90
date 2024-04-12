module Day1
	implicit none

	contains
		subroutine get_line(io, line, iostat)
			integer, intent(in) :: io
			character(len=:), intent(out), allocatable :: line
			integer, intent(out) :: iostat

			integer, parameter :: buffer_len = 80
			character(len=buffer_len) :: buffer
			integer :: size_read

			line = ''
			do
				read ( io, '(A)', iostat = iostat, advance = 'no', size = size_read ) buffer
				if (is_iostat_eor(iostat)) then
					line = line // buffer(:size_read)
					iostat = 0
				exit
				else if (iostat == 0) then
					line = line // buffer
				else
					exit
				end if
			end do
		end subroutine get_line
	
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