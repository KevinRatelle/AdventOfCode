
module Day2
	implicit none

	contains
		integer function ConvertToNumber(string, index) result(out)
			implicit none
			character(*), intent(in) :: string
			integer, intent(inout) :: index
			integer :: digit
			character char

			out = 0

			do
				char = string(index:index)
				if (char == 'x' .or. char == ' ') then
					index = index + 1
					exit
				end if

				out = out * 10
				read(char, *) digit
				out = out + digit

				index = index + 1
			end do
		end function ConvertToNumber

		integer function ConvertToSurface(string) result(out)
			implicit none
			character(*), intent(in) :: string
			integer, dimension(3) :: numbers
			integer :: dimension_index, index
			integer surface, smallest_surface
			out = 0
			index = 1
			dimension_index = 1
			do while (dimension_index <= 3)
				numbers(dimension_index) = ConvertToNumber(string, index)
				dimension_index = dimension_index + 1
			end do
			dimension_index = 1
			smallest_surface = huge(smallest_surface)
			do while (dimension_index <= 3)
				surface = numbers(dimension_index) * numbers(1 + modulo(dimension_index, 3))
				if (surface < smallest_surface) then
					smallest_surface = surface
				end if
				out = out + 2 * surface
				dimension_index = dimension_index + 1
			end do
			out = out + smallest_surface
		end function ConvertToSurface

		integer function ConvertDimensions(string) result(out)
			implicit none
			character(*), intent(in) :: string
			integer, dimension(3) :: numbers
			integer :: dimension_index, index
			integer volume, circum, smallest_circum
			out = 0

			index = 1
			dimension_index = 1
			do while (dimension_index <= 3)
				numbers(dimension_index) = ConvertToNumber(string, index)
				dimension_index = dimension_index + 1
			end do

			dimension_index = 1
			smallest_circum = huge(smallest_circum)
			do while (dimension_index <= 3)
				circum = numbers(dimension_index) + numbers(1 + modulo(dimension_index, 3))
				if (circum < smallest_circum) then
					smallest_circum = circum
				end if
				dimension_index = dimension_index + 1
			end do

			volume = numbers(1) * numbers(2) * numbers(3)
			out = smallest_circum * 2 + volume
		end function ConvertDimensions

		subroutine compute_solution(io, is_part_b)
			implicit none

			logical, intent(in) :: is_part_b
			integer, intent(in) :: io
			integer, parameter :: max_line_length = 100
			character(len=max_line_length) :: line
			integer :: total, number, iocode

			total = 0

			do
				read(io, *, iostat=iocode) line
				if (iocode /= 0) then
					exit
				end if

				if (is_part_b) then
					number = ConvertDimensions(line)
				else
					number = ConvertToSurface(line)
				end if

				total = total + number
			end do

			close(io)

			write(*,*) "The result is", total
		end subroutine compute_solution
end module Day2