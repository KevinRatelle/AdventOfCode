import std::io;
import std::collections::list;
import std::math;

struct State
{
    ulong a;
    ulong b;
    ulong c;
}

struct Computer
{
    State m_state;
    List(<ushort>) m_program;

    int m_pointer;
    List(<ulong>) m_output;
    bool m_halted;
    bool m_skip_increase;
}

fn void Computer.reset(Computer* this)
{
    this.m_pointer = 0;
    this.m_halted = false;
    this.m_skip_increase = false;
    this.m_output.free();
    this.m_state.b = 0;
    this.m_state.c = 0;
}

fn bool Computer.is_identical(Computer* this)
{
    if (this.m_output.len() != this.m_program.len())
    {
        return false;
    }

    for(int i = 0; i < this.m_output.len(); i++)
    {
        if (this.m_output[i] != this.m_program[i])
        {
            return false;
        }
    }

    return true;
}

fn ulong Computer.combo(Computer* this, ushort operand)
{
    if (operand < 4)
    {
        return operand;
    }

    switch(operand)
    {
        case 4:
        {
            return this.m_state.a;
        }
        case 5:
        {
            return this.m_state.b;
        }
        case 6:
        {
            return this.m_state.c;
        }
        case 7:
        {
            unreachable("Should not happen.");
        }
    }

    unreachable("Should not happen.");
}

fn void Computer.free(Computer* this)
{
    this.m_program.free();
    this.m_output.free();
}

fn ulong power(ulong val, ulong pow)
{
    if (pow == 0)
    {
        return 1;
    }

    ulong result = val;
    while(--pow)
    {
        result *= val;
    }

    return result;
}

fn void Computer.adv(Computer* this, ushort operand)
{
    ulong num = this.m_state.a;
    ulong pow = this.combo(operand);

    ulong den = power(2, pow);
    this.m_state.a = num / den;
}

fn void Computer.bxl(Computer* this, ushort operand)
{
    this.m_state.b = this.m_state.b ^ operand;
}

fn void Computer.bst(Computer* this, ushort operand)
{
    this.m_state.b = this.combo(operand) % 8;
}

fn void Computer.jnz(Computer* this, ushort operand)
{
    if (this.m_state.a == 0)
    {
        return;
    }

    this.m_pointer = operand / 2;
    this.m_skip_increase = true;
}

fn void Computer.bxc(Computer* this)
{
    this.m_state.b = this.m_state.b ^ this.m_state.c;
}

fn void Computer.out(Computer* this, ushort operand)
{
    ulong val = this.combo(operand);
    this.m_output.push((ulong) val % 8);
}

fn void Computer.bdv(Computer* this, ushort operand)
{
    ulong num = this.m_state.a;
    ulong pow = this.combo(operand);

    ulong den = power(2, pow);
    this.m_state.b = num / den;
}

fn void Computer.cdv(Computer* this, ushort operand)
{
    ulong num = this.m_state.a;
    ulong pow = this.combo(operand);

    ulong den = power(2, pow);
    this.m_state.c = num / den;
}

fn void Computer.tick(Computer* this)
{
    ushort opcode = this.m_program[this.m_pointer];
    ushort operand = this.m_program[(ulong) this.m_pointer+1];

    switch(opcode)
    {
        case 0:
        {
            this.adv(operand);
        }
        case 1:
        {
            this.bxl(operand);
        }
        case 2:
        {
            this.bst(operand);
        }
        case 3:
        {
            this.jnz(operand);
        }
        case 4:
        {
            this.bxc();
        }
        case 5:
        {
            this.out(operand);
        }
        case 6:
        {
            this.bdv(operand);
        }
        case 7:
        {
            this.cdv(operand);
        }
    }

    if (!this.m_skip_increase)
    {
        this.m_pointer+=2; // technically steps twice in memory
    }

    this.m_skip_increase = false;

    if (this.m_pointer >= this.m_program.len())
    {
        this.m_halted = true;
    }
}

fn Computer load_state(String[] lines)
{
    Computer computer;
    computer.m_pointer = 0;
    computer.m_halted = false;
    computer.m_skip_increase = false;

    bool reading_state = true;
    foreach(String line : lines)
    {
        if (line == "")
        {
            reading_state = false;
            continue;
        }

        if (reading_state)
        {
            String[] register_info = line.split(": ");
            defer free(register_info);

            String register_name = register_info[0];
            String register_value = register_info[1];

            char register_char = register_name[register_name.len - 1];
            ulong! val = register_value.to_ulong();
            if (catch err = val)
            {
                break;
            }

            switch(register_char)
            {
                case 'A':
                {
                    computer.m_state.a = val;
                }
                case 'B':
                {
                    computer.m_state.b = val;
                }
                case 'C':
                {
                    computer.m_state.c = val;
                }
            }
        }
        else
        {
            String[] program_string = line.split(": ");
            defer free(program_string);

            String[] program_content = program_string[1].split(",");
            defer free(program_content);

            ulong item_count = program_content.len;
            assert(item_count % 2 == 0);

            ulong instruction_count = item_count / 2;
            for (int i = 0; i<instruction_count; i++)
            {
                int index = i*2;
                ushort! opcode = program_content[index].to_ushort();
                if (catch err = opcode)
                {
                    break;
                }

                ushort! operand = program_content[index+1].to_ushort();
                if (catch err = operand)
                {
                    break;
                }

                computer.m_program.push(opcode);
                computer.m_program.push(operand);
            }
        }
    }

    return computer;
}

fn void process(String data, bool is_part_b)
{
    String[] lines = data.split("\r\n");
	defer free(lines);

    Computer computer = load_state(lines);
    defer computer.free();

    if (!is_part_b)
    {
        while(!computer.m_halted)
        {
            computer.tick();
        }

        io::printfn("Output is %s", computer.m_output);
    }
    else
    {
        // after investigation, the output repeats after 8 values, for each digit
        // for example, last digit do 4,4,5,6,0,1,2,3, but then do 4 8 times, 4 8 times, 5 8 times, etc, so
        // so we loop until last digit = what we want, then we multiply the index by 8 then go to the next digit

        ulong a = 0;
        int digit_index = (int) computer.m_program.len() - 1;
        while(digit_index>=0)
        {
            computer.reset();
            computer.m_state.a = a;

            while(!computer.m_halted)
            {
                computer.tick();
            }

            io::printfn("Output is %s", computer.m_output);
            if (digit_index == 0 && computer.is_identical())
            {
                break;
            }

            if (digit_index > 0 && computer.m_output[0] == computer.m_program[digit_index])
            {
                digit_index--;
                a *= 8;   
            }
            else
            {
                a++;
            }
        }

        io::printfn("Register a needs to be %d", a);
    }
    
}