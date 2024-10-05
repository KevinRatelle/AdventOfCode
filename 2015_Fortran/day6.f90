
module Day6

	implicit none

	enum, bind(C)
		enumerator :: TOGGLE = 1
		enumerator :: ON = 2
		enumerator :: OFF = 3
	end enum

contains
		integer function ConvertToNumber(string) result(out)
			implicit none
			character(*), intent(in) :: string
			integer :: digit, index
			character char

			out = 0

			do index = 1,string%len
				char = string(index:index)

				out = out * 10
				read(char, *) digit
				out = out + digit
			end do
		end function ConvertToNumber

		! split a string into 2 either side of a delimiter token
		subroutine SplitString(instring, string1, string2, delim)
			implicit none
			character(*) :: instring, delim
			character(len=:), allocatable, intent(out):: string1, string2
			integer :: index

			index = scan(instring, delim)
			string2 = instring(index+1:)
			string1 = instring(1:index-1)
		end subroutine SplitString

		subroutine DecodeMinMax(string, min, max)
			character(*), intent(in) :: string
			integer, intent(inout):: min, max

			character(len=:), allocatable :: a, b


			call SplitString(string, a, b, ",")
			min = ConvertToNumber(a)
			max = ConvertToNumber(b)
		end subroutine DecodeMinMax

		subroutine DecodeRange(string, range)
			implicit none
			character(*), intent(in) :: string
			integer, dimension(4), intent(inout) :: range
			character(len=:), allocatable :: a, b

			call SplitString(string, a, b, " through")
			b = b(9:)
			call DecodeMinMax(a, range(1), range(2))
			call DecodeMinMax(b, range(3), range(4))
		end subroutine DecodeRange

		subroutine ExecuteOnGrid(lights, string, option, is_part_b)
			implicit none
			integer, dimension(1000,1000), intent(inout) :: lights
			logical, intent(in) :: is_part_b
			character(*), intent(in) :: string
			integer, intent(in) :: option
			integer :: change

			integer :: r(4)
			call DecodeRange(string, r)

			if (is_part_b) then
				if (option == TOGGLE) then
					change = 2
				else if (option == ON) then
					change = 1
				else if (option == OFF) then
					change = -1
				end if
				lights(r(1):r(3), r(2):r(4)) = max(lights(r(1):r(3), r(2):r(4)) + change, 0)
			else
				if (option == TOGGLE) then
					lights(r(1):r(3), r(2):r(4)) = 1 - (lights(r(1):r(3), r(2):r(4)))
				else if (option == ON) then
					lights(r(1):r(3), r(2):r(4)) = 1
				else if (option == OFF) then
					lights(r(1):r(3), r(2):r(4)) = 0
				end if
			end if
		end subroutine ExecuteOnGrid

		subroutine ExecuteLine(string, lights, is_part_b)
			implicit none
			character(*), intent(in) :: string
			integer, dimension(1000,1000), intent(inout) :: lights
			logical, intent(in) :: is_part_b
			character(len=:), allocatable :: a, b, c

			call SplitString(string, a, b, " ")
			if (a == 'turn') then
				call SplitString(b, a, c, " ")
				if (a == 'on') then
					call ExecuteOnGrid(lights, c, ON, is_part_b)
				else
					call ExecuteOnGrid(lights, c, OFF, is_part_b)
				end if
			end if

			if (a == 'toggle') then
				call ExecuteOnGrid(lights, b, TOGGLE, is_part_b)
			end if
		end subroutine ExecuteLine

	subroutine compute_solution(io, is_part_b)
		implicit none
		integer, intent(in) :: io
		logical, intent(in) :: is_part_b

		integer, parameter :: max_line_length = 100
		character(len=max_line_length) :: line
		character(len=:), allocatable :: line_trimmed
		integer :: iocode
		integer, dimension(1000,1000) :: lights
		lights = 0

		do
			read(io, '(a)', iostat=iocode) line

			line_trimmed = trim(line)

			if (iocode /= 0) then
				exit
			end if

			call ExecuteLine(line_trimmed, lights, is_part_b)
		end do

		write(*,*) "The result is", sum(lights)
	end subroutine compute_solution
end module Day6