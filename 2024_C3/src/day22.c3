import std::io;
import std::collections::list;

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

fn void process(String data, bool is_part_b)
{
    String[] list = data.split("\r\n");
	defer free(list);

    ulong total = 0;
    List(<ulong>) prices;

    foreach(item : list)
    {
        ulong! value = item.to_ulong();
        if (catch err = value)
        {
            continue;
        }

        ulong result = compute_next_steps(value, 2000);
        total += result;

        prices.push(result % 10);
    }

    foreach(price : prices)
    {
        io::printn(price);
    }

    io::printfn("Total is %d", total);
}