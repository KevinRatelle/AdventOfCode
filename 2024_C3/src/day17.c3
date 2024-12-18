import std::io;
import std::collections::list;
import std::math;

struct State
{
    uint a;
    uint b;
    uint c;
}

struct Instruction
{
    ushort opcode;
    ushort operand;
}

struct Computer
{
    State m_state;
    List(<Instruction>) m_program;

    int m_pointer;
    List(<uint>) m_output;
    bool m_halted;
    bool m_skip_increase;
}

fn uint Computer.combo(Computer* this, ushort operand)
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

fn uint power(uint val, uint pow)
{
    if (pow == 0)
    {
        return 1;
    }

    uint result = val;
    while(--pow)
    {
        result *= val;
    }

    return result;
}

fn void Computer.adv(Computer* this, ushort operand)
{
    uint num = this.m_state.a;
    uint pow = this.combo(operand);

    uint den = power(2, pow);
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
    uint val = this.combo(operand);
    this.m_output.push(val % 8);
}

fn void Computer.bdv(Computer* this, ushort operand)
{
    uint num = this.m_state.a;
    uint pow = this.combo(operand);

    uint den = power(2, pow);
    this.m_state.b = num / den;
}

fn void Computer.cdv(Computer* this, ushort operand)
{
    uint num = this.m_state.a;
    uint pow = this.combo(operand);

    uint den = power(2, pow);
    this.m_state.c = num / den;
}

fn void Computer.tick(Computer* this)
{
    Instruction instruction = this.m_program[this.m_pointer];

    switch(instruction.opcode)
    {
        case 0:
        {
            this.adv(instruction.operand);
        }
        case 1:
        {
            this.bxl(instruction.operand);
        }
        case 2:
        {
            this.bst(instruction.operand);
        }
        case 3:
        {
            this.jnz(instruction.operand);
        }
        case 4:
        {
            this.bxc();
        }
        case 5:
        {
            this.out(instruction.operand);
        }
        case 6:
        {
            this.bdv(instruction.operand);
        }
        case 7:
        {
            this.cdv(instruction.operand);
        }
    }

    if (!this.m_skip_increase)
    {
        this.m_pointer++; // technically steps twice in memory
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
            uint! val = register_value.to_uint();
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

            uint item_count = program_content.len;
            assert(item_count % 2 == 0);

            uint instruction_count = item_count / 2;
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

                Instruction instruction;
                instruction.opcode = opcode;
                instruction.operand = operand;
                computer.m_program.push(instruction);
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

    io::printn(computer);

    while(!computer.m_halted)
    {
        computer.tick();
    }

        io::printn(computer);


    io::printfn("Total is %d", 0);
}