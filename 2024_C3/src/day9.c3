import std::io;
import std::collections::list;

fn List(<int>) fill_memory(String data)
{
    uint file_id = 0;

    List(<int>) mem;
    for (int i = 0, bool file = true; i < data.len; i++, file = !file)
    {
        uint size = data[i] - 48;
        for (int block = 0; block < size; block++)
        {
            mem.push(file ? file_id : -1);
        }

        file_id += file ? 1 : 0;
    }

    return mem;
}

fn ulong compute_checksum(List(<int>) mem)
{
    ulong checksum = 0;
    for(int i = 0; i < mem.len(); i++)
    {
        if (mem[i] == -1)
        {
            continue;
        }

        checksum += (ulong) (mem[i] * i);
    }
    return checksum;
}

fn void defragment_dense(List(<int>) mem)
{
    uint it = 0;
    uint rit = (uint) mem.len() - 1;

    while(it <= rit)
    {
        if (mem[it] == -1)
        {
            while(mem[rit] == -1)
            {
                rit--;
            }
            mem[it] = mem[rit];
            mem[rit--] = -1;
        }
        it++;
    }
}

fn uint space_size(List(<int>) mem, uint index)
{
    uint count = 0;
    while(index < mem.len() && mem[index] == -1)
    {
        count++;
        index++;
    }

    return count;
}

fn int seek_location(List(<int>) mem, uint file_start, uint file_size)
{
    uint end_search_location = file_start - file_size + 1;
    for (int i = 0; i < end_search_location; i++)
    {
        if (space_size(mem, i) >= file_size)
        {
            return i;
        }
    }

    return -1;
}

fn void defragment_preserve_file(List(<int>) mem)
{
    int rit = (int) mem.len() - 1;
    while(rit >= 0)
    {
        int file_id = mem[rit];
        if(file_id == 0)
        {
            break;
        }

        if (file_id == -1)
        {
            rit--;
            continue;
        }

        uint file_size = 0;
        while(mem[rit] == file_id)
        {
            file_size++;
            rit--;
        }

        uint file_start = rit + 1;
        int location_found = seek_location(mem, file_start, file_size);
        if (location_found != -1)
        {
            for(int i = 0; i < file_size; i++)
            {
                mem[(ulong) location_found + i] = file_id;
                mem[(ulong) file_start + i] = -1;
            }
        }
    }
}

fn void process(String data, bool is_part_b, bool verbose)
{
    List(<int>) mem = fill_memory(data);
    defer mem.free();

    if (is_part_b)
    {
        defragment_preserve_file(mem);
    }
    else
    {
        defragment_dense(mem);
    }

    ulong checksum = compute_checksum(mem);
    io::printfn("Checksum is %d", checksum);
}