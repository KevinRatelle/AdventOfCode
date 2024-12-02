
import std::io;
import std::collections::list;

fn bool is_report_safe(String[] report)
{
    int previous_variation = 0;
    for (int i = 1; i < report.len; i++)
    {
        int! value = report[i].to_int();
        if (catch err = value)
        {
            return false;
        }

        int! previous = report[i-1].to_int();
        if (catch err = previous)
        {
            return false;
        }

        int variation = value - previous;
        if ($$abs(variation) > 3 || variation == 0)
        {
            return false;
        }
        
        if (variation * previous_variation < 0)
        {
            return false;
        }

        previous_variation = variation;
    }

    return true;
}

fn bool is_report_safe_with_dampener(String[] report)
{
    if (is_report_safe(report))
    {
        return true;
    }

    for(int i = 0; i < report.len; i++)
    {
        List(<String>) copy;
        copy.add_array(report);
        copy.remove_at(i);

        if (is_report_safe(copy.to_tarray()))
        {
            return true;
        }
    }

    return false;
}

fn void process(String[] lines, bool is_part_b)
{
    uint safe_count = 0;

    for (int i = 0; i < lines.len; i++)
    {
        String[] values = lines[i].split(" ");
        if (values.len < 1)
        {
            break;
        }

        if (is_part_b)
        {
            if (is_report_safe_with_dampener(values))
            {
                safe_count++;
            }
        }
        else if (is_report_safe(values))
        {
            safe_count++;
        }
    }

    io::printfn("Total is %d", safe_count);
}