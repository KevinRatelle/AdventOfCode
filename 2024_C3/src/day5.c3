import std::io;
import std::collections::list;

struct Order
{
    uint before;
    uint after;
}

fn bool is_order_valid(List(<Order>) orders, List(<uint>) chain)
{
    for (uint i = 0; i < (chain.len()-1); i++)
    {
        uint next = i+1;
        foreach(Order order : orders)
        {
            if (order.before == chain[i] && order.after == chain[next])
            {
                break;
            }
            else if (order.before == chain[next] && order.after == chain[i])
            {
                return false;
            }
        }
    }

    return true;
}

fn void reorder_chain(List(<Order>) orders, List(<uint>) chain)
{
    while (!is_order_valid(orders, chain))
    {
        for (uint i = 0; i < (chain.len()-1); i++)
        {
            uint next = i+1;
            foreach(Order order : orders)
            {
                if (order.before == chain[next] && order.after == chain[i])
                {
                    uint buf = chain[next];
                    chain[next] = chain[i];
                    chain[i] = buf;
                }
            }
        }
    }
}


fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<Order>) orders;
    uint count = 0;

    bool reading_page_order = true;
    foreach(line : lines)
    {
        if (reading_page_order)
        {
            if (line == "")
            {
                reading_page_order = false;
                continue;
            }

            String[] pages_str = line.split("|");

            uint! before = pages_str[0].to_uint();
            if (catch err = before)
            {
                continue;
            }

            uint! after = pages_str[1].to_uint();
            if (catch err = after)
            {
                continue;
            }

            Order order;
            order.before = before;
            order.after = after;
            orders.push(order);
        }
        else
        {
            String[] chain_str = line.split(",");
            List(<uint>) chain;
            foreach(item : chain_str)
            {
                uint! page = item.to_uint();
                if (catch err = page)
                {
                    continue;
                }

                chain.push(page);
            }

            if (!is_part_b && is_order_valid(orders, chain))
            {
                usz middle_index = chain.len() / 2;
                uint middle = chain[middle_index];
                count += middle;
            }
            if (is_part_b && !is_order_valid(orders, chain))
            {
                reorder_chain(orders, chain);
                usz middle_index = chain.len() / 2;
                uint middle = chain[middle_index];
                count += middle;
            }
        }
    }


    io::printfn("Total is %d", count);
}