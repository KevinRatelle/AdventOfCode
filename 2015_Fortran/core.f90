
module Core
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
end module Core
