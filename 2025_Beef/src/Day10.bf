namespace _2025_Beef;

using System;
using System.Collections;

class Day10
{
	const public uint8 k_max = 10;

	struct Button
	{
		public uint8[k_max] m_targets;
		public uint8 m_count;

		public this()
		{
			m_count = 0;
			m_targets = .(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
		}

		public void Add(uint8 target) mut
		{
			m_targets[m_count++] = target;
		}
	}

	struct Machine
	{
		public List<Button> m_buttons;

		public bool[k_max] m_state;
		public bool[k_max] m_target;

		public int16[k_max] m_voltState;
		public int16[k_max] m_voltTarget;

		public void PressButton(uint32 button) mut
		{
			for (let targetIndex in (0 ... m_buttons[button].m_count - 1))
			{
				let target = m_buttons[button].m_targets[targetIndex];
				m_state[target] = !m_state[target];
			}
		}

		public void PressVoltButton(uint32 button) mut
		{
			for (let targetIndex in (0 ... m_buttons[button].m_count - 1))
			{
				let target = m_buttons[button].m_targets[targetIndex];
				m_voltState[target]++;
			}
		}

		public bool IsValid()
		{
			for (int i = 0; i < m_state.Count; i++)
			{
				if (m_state[i] != m_target[i])
				{
					return false;
				}
			}

			return true;
		}

		public void Clear()
		{
			delete m_buttons;
		}

		public this(StringView line)
		{
			m_buttons = new List<Button>();

			m_state = .(false, false, false, false, false, false, false, false, false, false);
			m_target = m_state;

			m_voltState = .(0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			m_voltTarget = m_voltState;

			for (int32 c = 0; c < line.Length; c++)
			{
				if (line[c] == '[')
				{
					uint8 cur = 0;
					for (c = c + 1; c < line.Length; c++)
					{
						if (line[c] == ']')
						{
							c++;
							break;
						}

						if (line[c] == '.')
						{
							m_target[cur] = false;
						}
						else if (line[c] == '#')
						{
							m_target[cur] = true;
						}

						m_state[cur++] = false;
					}
				}

				if (line[c] == '(')
				{
					var button = Button();

					for (c = c + 1; c < line.Length; c++)
					{
						if (line[c] == ',')
						{
							// nothing
						}
						else if (line[c] == ')')
						{
							c++;
							break;
						}
						else
						{
							button.Add(uint8.Parse(line[c ... c]));
						}
					}

					m_buttons.Add(button);
				}

				if (line[c] == '{')
				{
					uint8 cur = 0;
					for (c = c + 1; c < line.Length; c++)
					{
						if (line[c] == ',')
						{
							// nothing
						}
						else if (line[c] == '}')
						{
							c++;
							break;
						}
						else
						{
							//m_voltTarget[cur] = int16.Parse(line[c ... c]);
							//m_voltState[cur++] = 0;
						}
					}
				}
			}
		}
	}

	static void ComputeMinimumCount(ref Machine machine, uint32 countin, ref uint32 depth)
	{
		uint32 count = countin;

		if (machine.IsValid())
		{
			if (count < depth)
			{
				depth = count;
			}

			return;
		}

		if (count > 5)
		{
			return;
		}

		count++;
		for (uint32 button = 0; button < machine.m_buttons.Count; button++)
		{
			machine.PressButton(button);
			ComputeMinimumCount(ref machine, count, ref depth);
			machine.PressButton(button); // untoggle after done
		}
	}

	static public void Execute(List<String> lines, bool isPartB)
	{
		uint32 count = 0u;

		for (int32 i = 0; i < lines.Count; i++)
		{
			StringView line = lines[i];

			Console.Write("Step {} of {} : ", i, lines.Count);

			var machine = Machine(line);
			uint32 minimumCount = 0;
			uint32 depth = 1000;
			ComputeMinimumCount(ref machine, minimumCount, ref depth);
			Runtime.Assert(depth != 1000);
			count += depth;
			machine.Clear();

			Console.WriteLine("{}", depth);
		}

		Console.WriteLine("Count is {}", count);
	}
}