namespace _2025_Beef;

using System;
using System.Collections;

class Day10
{
	struct Button
	{
		public List<uint8> m_targets;

		public this()
		{
			m_targets = new List<uint8>();
		}

		public void Clear()
		{
			delete m_targets;
		}
	}

	struct Machine
	{
		public List<bool> m_state;
		public List<bool> m_target;
		public List<Button> m_buttons;

		public void PressButton(uint32 button)
		{
			for (let target in m_buttons[button].m_targets)
			{
				m_state[target] = !m_state[target];
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

		public this()
		{
			m_state = new List<bool>();
			m_target = new List<bool>();
			m_buttons = new List<Button>();
		}

		public void Clear()
		{
			delete m_state;
			delete m_target;
			for (var button in m_buttons)
			{
				button.Clear();
			}
			delete m_buttons;
		}

		public this(StringView line)
		{
			m_state = new List<bool>();
			m_target = new List<bool>();
			m_buttons = new List<Button>();

			for (int32 c = 0; c < line.Length; c++)
			{
				if (line[c] == '[')
				{
					for (c = c + 1; c < line.Length; c++)
					{
						if (line[c] == ']')
						{
							c++;
							break;
						}

						if (line[c] == '.')
						{
							m_target.Add(false);
						}
						else if (line[c] == '#')
						{
							m_target.Add(true);
						}

						m_state.Add(false);
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
							break;
						}
						else
						{
							button.m_targets.Add(uint8.Parse(line[c ... c]));
						}
					}

					m_buttons.Add(button);
				}

				if (line[c] == '{')
				{
					break;
				}
			}
		}
	}

	static void ComputeMinimumCount(Machine machine, uint32 countin, ref uint32 depth)
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
			ComputeMinimumCount(machine, count, ref depth);
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
			ComputeMinimumCount(machine, minimumCount, ref depth);
			Runtime.Assert(depth != 1000);
			count += depth;
			machine.Clear();

			Console.WriteLine("{}", depth);
		}

		Console.WriteLine("Count is {}", count);
	}
}