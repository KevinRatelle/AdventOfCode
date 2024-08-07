
module Day3
	use Core

	type Position
		integer :: x
		integer :: y
	end type

	contains
		logical function WasVisited(visited_cells, current_cell) result(out)
			implicit none
			type(Position), dimension(:), intent(in) :: visited_cells
			type(Position), intent(in) :: current_cell
			integer :: index

			out = .False.
			do index = 1,size(visited_cells)
				if ((current_cell%x .eq. visited_cells(index)%x) .and. (current_cell%y .eq. visited_cells(index)%y)) then
					out = .True.
					exit
				end if
			end do
		end function WasVisited

		subroutine TestCharacter(char, visited_cells, current_cell)
			implicit none
			character, intent(in) :: char
			type(Position), dimension(:), allocatable, intent(inout) :: visited_cells
			type(Position), dimension(:), allocatable :: temp
			type(Position), intent(inout) :: current_cell
			integer :: size_old

			if (char == ' ') then
				return
			end if

			if (char == '>') then
				current_cell%x = current_cell%x + 1
			end if

			if (char == '<') then
				current_cell%x = current_cell%x - 1
			end if

			if (char == '^') then
				current_cell%y = current_cell%y + 1
			end if

			if (char == "v") then
				current_cell%y = current_cell%y - 1
			end if

			if (.not. WasVisited(visited_cells, current_cell)) then
				size_old = size(visited_cells)
				allocate(temp(size_old+1))
				temp(1:size_old) = visited_cells(1:size_old)
				call move_alloc(temp, visited_cells)
				visited_cells(size_old+1) = current_cell
			end if
		end subroutine TestCharacter

		subroutine compute_solution(io, is_part_b)
			implicit none

			integer, intent(in) :: io
			logical, intent(in) :: is_part_b

			character(len=:), allocatable :: line
			integer :: index = 0, total = 0, iostat = 0
			type(Position), dimension(:), allocatable :: visited_cells
			type(Position) :: current_cell
			type(Position) :: current_robo
			character :: char
			logical :: is_robot

			current_cell = Position(0, 0)
			current_robo = Position(0, 0)
			allocate (visited_cells(1))
			visited_cells(1) = current_cell

			call get_line(io, line, iostat)

			is_robot = .false.

			do index = 1, line.len
				char = line(index:index)

				if (is_part_b) then
					if (is_robot) then
						call TestCharacter(char, visited_cells, current_cell)
					else 
						call TestCharacter(char, visited_cells, current_robo)
					end if
				else
					call TestCharacter(char, visited_cells, current_cell)
				end if

				is_robot = .not. is_robot
			end do

			close(io)

			total = size(visited_cells)
			write(*,*) "The result is", total
		end subroutine compute_solution
end module Day3