import std::io;

fn void process(String data, bool is_part_b)
{
    uint id_count = (data.len + 1) / 2 - 1;
    uint forward_cursor = 0;
    uint backward_cursor = data.len - 1;

    ulong total = 0;
    uint multiplier = 0;
    uint id = 0;
    uint rid = id_count+1;

    uint left_from_back = 0;
    while MAIN: (id < rid)
    {
        uint item_count = data[forward_cursor++] - 48;
        for(int i = 0; i < item_count; i++)
        {
            total += (ulong) (id * multiplier++);
        }

        uint empty_count = data[forward_cursor++] - 48;
        for(int i = 0; i < empty_count; i++)
        {
            while (left_from_back == 0)
            {
                rid--;
                left_from_back = data[backward_cursor--] - 48;
                backward_cursor--;
            }
            total += (ulong) (rid * multiplier++);
            left_from_back--;
        }

        id++;
    }

    while(left_from_back > 0)
    {
        total += (ulong) (rid * multiplier++);
        left_from_back--;
    }

    io::printfn("Total is %d", total);
}