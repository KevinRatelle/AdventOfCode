
include "day1.f90"

program main
    use Day1

    implicit none
    integer :: io
    logical :: is_part_b = .false.

    open(newunit=io, file="day1.txt")
    call compute_solution(io, is_part_b)
    close(io)
end program main