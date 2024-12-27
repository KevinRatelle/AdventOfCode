import std::io;
import std::collections::list;

struct Connection
{
    String a;
    String b;
}

fn String Connection.connected_node(Connection* this, Connection other)
{
    if (this.a == other.a || this.a == other.b)
    {
        return this.a;
    }
    else if (this.b == other.a || this.b == other.b)
    {
        return this.b;
    }

    return "";
}

fn bool Connection.equals(Connection* this, Connection other)
{
    return this.a == other.a && this.b == other.b ||
           this.b == other.a && this.a == other.b;
}

struct Lan
{
    String a;
    String b;
    String c;
}

def BigLan = List(<String>);

fn List(<Lan>) compute_lans(List(<Connection>)* connections)
{
    List(<Lan>) lans;

    for(int i = 0; i < connections.len(); i++)
    {
        Connection connection = connections.get(i);
        for(int j = i+1; j < connections.len(); j++)
        {
            Connection other = connections.get(j);
            String connect = connection.connected_node(other);
            if (connect != "")
            {
                Connection to_find;
                to_find.a = connection.a == connect ? connection.b : connection.a;
                to_find.b = other.a == connect ? other.b : other.a;

                for (int k = j+1; k < connections.len(); k++)
                {
                    Connection third = connections.get(k);

                    if (third.equals(to_find))
                    {
                        Lan lan;
                        lan.a = connect;
                        lan.b = third.a;
                        lan.c = third.b;
                        lans.push(lan);
                    }
                }
            }
        }
    }

    return lans;
}

fn bool is_in_biglan(BigLan* biglan, String computer)
{
    for(int i = 0; i < biglan.len(); i++)
    {
        if (biglan.get(i) == computer)
        {
            return true;
        }
    }

    return false;
}

fn bool is_connected_node(List(<Connection>)* connections, Connection connection)
{
    for(int j = 0; j < connections.len(); j++)
    {
        Connection other = connections.get(j);
        if (other.equals(connection))
        {
            return true;
        }
    }

    return false;
}

fn bool is_connected_to_biglan(BigLan* biglan, String computer, List(<Connection>)* connections)
{
    for(int i = 0; i < biglan.len(); i++)
    {
        Connection connection;
        connection.a = biglan.get(i);
        connection.b = computer;

        bool is_connect = is_connected_node(connections, connection);
        if (!is_connect)
        {
            return false;
        }
    }

    return true;
}

fn void compute_biglan(BigLan* biglan, List(<Connection>)* connections, List(<String>)* computers)
{
    for(int i = 0; i < computers.len(); i++)
    {
        if (is_in_biglan(biglan, computers.get(i)))
        {
            continue;
        }

        if (is_connected_to_biglan(biglan, computers.get(i), connections))
        {
            biglan.push(computers.get(i));
        }
    }
}

fn BigLan find_big_lan(List(<Lan>)* lans, List(<Connection>)* connections, List(<String>)* computers, bool verbose)
{
    BigLan out;

    for(int i = 0; i < lans.len(); i++)
    {
        if (verbose && i % 100 == 0)
        {
            io::printfn("Testing lan %d of %d", i, lans.len());
        }

        Lan lan = lans.get(i);

        BigLan biglan;
        biglan.push(lan.a);
        biglan.push(lan.b);
        biglan.push(lan.c);

        compute_biglan(&biglan, connections, computers);
        if (biglan.len() > out.len())
        {
            out = biglan;
        }
    }

    return out;
}

fn bool bigger(String a, String b)
{
    if (a[0] == b[0])
    {
        return a[1] > b[1];
    }

    return a[0] > b[0];
}

fn uint to_value(String a)
{
    return a[0] << 8 + a[1];
}

fn BigLan sort_big_lan(BigLan* biglan)
{
    BigLan sorted;

    while(biglan.len() > 0)
    {
        uint index = 0;
        uint smallest = uint.max;
        for (int i = 0; i < biglan.len(); i++)
        {
            uint value = to_value(biglan.get(i));
            if (value < smallest)
            {
                smallest = value;
                index = i;
            }
        }

        sorted.push(biglan.get(index));
        biglan.remove_at(index);
    }

    return sorted;
}

fn String to_string(BigLan* biglan)
{
    List(<char>) list;
    foreach(i, str : biglan)
    {
        if (i != 0)
        {
            list.push(',');
        }

        foreach(c : str)
        {
            list.push(c);
        }
    }

    return (String) list.to_tarray();
}

fn void process(String data, bool is_part_b, bool verbose)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<Connection>) connections;
    List(<String>) computers;

    foreach(String line : lines)
    {
        String[] pair = line.split("-");
        defer free(pair);

        Connection connection;
        connection.a = pair[0];
        connection.b = pair[1];
        connections.push(connection);

        if (!computers.contains(connection.a))
        {
            computers.push(connection.a);
        }

        if (!computers.contains(connection.b))
        {
            computers.push(connection.b);
        }
    }

    List(<Lan>) lans = compute_lans(&connections);

    if (is_part_b)
    {
        BigLan biglan = find_big_lan(&lans, &connections, &computers, verbose);
        biglan = sort_big_lan(&biglan);

        String output = to_string(&biglan);
        io::printfn("Result is %s", output);
    }
    else
    {
        ulong count = 0;
        foreach(lan : lans)
        {
            if (lan.a[0] == 't' || lan.b[0] == 't' || lan.c[0] == 't')
            {
                count++;
            }
        }

        io::printfn("Total is %d", count);
    }
}