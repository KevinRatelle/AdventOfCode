

module Day5
	implicit none

	contains
		logical function IsVowel(char) result (is_vowel)
			implicit none
			character, intent(in) :: char

			is_vowel = .false.

			if (char == 'a' .or. char == 'e' .or. char == 'i' .or. char == 'o' .or. char == 'u') then
				is_vowel = .true.
			end if
		end function IsVowel

		logical function IsBadPair(string) result (is_bad_pair)
			implicit none
			character(*), intent(in) :: string

			is_bad_pair = .false.

			if (string == 'ab' .or. string == 'cd' .or. string == 'pq' .or. string == 'xy') then
				is_bad_pair = .true.
			end if
		end function IsBadPair

		logical function HasDoublePair(str) result (has_double)
			implicit none
			character(*), intent(in) :: str
			integer i, j

			has_double = .False.

			do i = 1, (str%len-3)
				do j = i+2, (str%len-1)
					if (str(i:i+1) == str(j:j+1)) then
						has_double = .True.
					end if
				end do
			end do
		end function HasDoublePair

		logical function HasRepeatedLetter(str) result (has_repeated_letter)
			implicit none
			character(*), intent(in) :: str
			integer i

			has_repeated_letter = .False.

			do i = 1, (str%len-2)
				if (str(i:i) == str(i+2:i+2)) then
					has_repeated_letter = .True.
				end if
			end do
		end function HasRepeatedLetter


		logical function IsStringNice(string) result(is_nice)
			implicit none
			character(*), intent(in) :: string

			is_nice = .true.

			block
				integer vowel_count
				integer index

				vowel_count = 0

				do index = 1, string%len
					if (IsVowel(string(index:index))) then
						vowel_count = vowel_count + 1
					end if
				end do

				if (vowel_count < 3) then
					is_nice = .false.
				end if
			end block

			block
				logical has_double
				integer index

				index = 0
				has_double = .false.

				do index = 1, (string%len-1)
					if (string(index:index) == string(index+1:index+1)) then
						has_double = .true.
					end if
				end do
				if (.not. has_double) then
					is_nice = .false.
				end if
			end block

			block
				logical contains_bad_string
				integer index

				index = 0
				contains_bad_string = .false.

				do index = 1, (string%len-1)
					if (IsBadPair(string(index:index+1))) then
						contains_bad_string = .True.
					end if
				end do

				if (contains_bad_string) then
					is_nice = .False.
				end if
			end block
		end function IsStringNice

		logical function IsStringNice_PartB(string) result(is_nice)
			implicit none
			character(*), intent(in) :: string

			is_nice = .True.

			if (.not. HasDoublePair(string)) then
				is_nice = .False.
			end if

			if (.not. HasRepeatedLetter(string)) then
				is_nice = .False.
			end if
		end function IsStringNice_PartB

		subroutine compute_solution(io, is_part_b)
			implicit none

			integer, intent(in) :: io
			logical, intent(in) :: is_part_b
			integer, parameter :: max_line_length = 100
			character(len=max_line_length) :: line
			character(len=:), allocatable :: line_trimmed
			integer :: total, iocode, index

			total = 0

			do
				read(io, *, iostat=iocode) line

				line_trimmed = trim(line)

				if (iocode /= 0) then
					exit
				end if

				if ((is_part_b .and. IsStringNice_PartB(line_trimmed)) .or. &
					 (.not. is_part_b .and. IsStringNice(line_trimmed))) then
					total = total + 1
				end if
			end do

			close(io)

			write(*,*) "The result is", total
		end subroutine compute_solution
end module Day5