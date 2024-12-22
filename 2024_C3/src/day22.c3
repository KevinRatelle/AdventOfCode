import std::io;
import std::collections::list;

struct ValueChange
{
    long value;
    long change;
}

def ValueChangeList = List(<ValueChange>);

fn ulong mix(ulong secret, ulong value)
{
    return secret ^ value;
}

fn ulong prune(ulong secret)
{
    return secret % 16777216;
}

fn ulong compute_next(ulong secret)
{
    secret = prune(mix(secret, secret * 64));
    secret = prune(mix(secret, secret / 32));
    secret = prune(mix(secret, secret * 2048));
    return secret;
}

fn ulong compute_next_steps(ulong secret, uint steps)
{
    for(int i = 0; i<steps; i++)
    {
        secret = compute_next(secret);
    }

    return secret;
}

fn ValueChangeList compute_prices(ulong secret, uint steps)
{
    ValueChangeList prices;

    long prev = secret % 10;
    for(int i = 0; i<steps; i++)
    {
        secret = compute_next(secret);
        long value = secret % 10;

        ValueChange val_change;
        val_change.value = value;
        val_change.change = val_change.value - prev;
        prices.push(val_change);

        prev = value;
    }

    return prices;
}

fn long compute_sold_count(ValueChangeList* prices, long[4]* sequence)
{
    for(long j = 0; j < (prices.len()-3); j++)
    {
        if ((prices.get(j+0).change == (*sequence)[0]) &&
            (prices.get(j+1).change == (*sequence)[1]) &&
            (prices.get(j+2).change == (*sequence)[2]) &&
            (prices.get(j+3).change == (*sequence)[3]))
        {
            return prices.get(j+3).value;
        }
    }

    return 0;
}

fn long compute_sold_count_total(List(<ValueChangeList>)* all_prices, long[4]* sequence, long start)
{
    long sold_count;

    for(long i = start; i < all_prices.len(); i++)
    {
        ValueChangeList cl = all_prices.get(i);
        sold_count += compute_sold_count(&cl, sequence);
    }

    return sold_count;
}

fn void process(String data, bool is_part_b)
{
    String[] list = data.split("\r\n");
	defer free(list);

    long total = 0;
    List(<ValueChangeList>) all_prices;

    foreach(item : list)
    {
        long! value = item.to_long();
        if (catch err = value)
        {
            continue;
        }

        if (!is_part_b)
        {
            long result = compute_next_steps(value, 2000);
            total += result;
        }
        else
        {
            ValueChangeList prices = compute_prices(value, 2000);
            all_prices.push(prices);
        }
    }

    if (is_part_b)
    {
        List(<ulong>) checked;
        foreach (i, prices : &all_prices)
        {
            io::printfn("Current step %d of %d", i+1, all_prices.len());

            for(long j = 0; j < (prices.len()-3); j++)
            {
                long[4] sequence;
                sequence[0] = prices[j+0].change;
                sequence[1] = prices[j+1].change;
                sequence[2] = prices[j+2].change;
                sequence[3] = prices[j+3].change;

                long key = sequence[0] * 1000000 + sequence[1] * 10000 + sequence[2] * 100 + sequence[3];
                if (checked.contains(key))
                {
                    continue;
                }

                if (checked.len() % 100 == 0)
                {
                    io::printfn("Checked items count %d", checked.len());
                }

                checked.push(key);

                long value = compute_sold_count_total(&all_prices, &sequence, i);     
                if (value > total)
                {
                    io::printfn("New best value %d", value);
                    total = value;
                }
            }
        }
    }

    io::printfn("Total is %d", total);
}