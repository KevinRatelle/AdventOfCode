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

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    List(<Connection>) connections;


    foreach(String line : lines)
    {
        String[] pair = line.split("-");
        defer free(pair);

        Connection connection;
        connection.a = pair[0];
        connection.b = pair[1];
        connections.push(connection);
    }

    List(<Lan>) lans = compute_lans(&connections);

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