module day6;

import std.conv;
import std.digest.md;
import std.stdio;

struct CharacterOccurence
{
	char m_char;
	int m_occurence;
}

struct CharacterOccurenceList
{
	CharacterOccurence[] m_char_occ;

	int get_index(char char_in) const
	{
		for(int i = 0; i < m_char_occ.length; i++)
		{
			if (m_char_occ[i].m_char == char_in)
			{
				return i;
			}
		}

		return -1;
	}

	void append(char char_in)
	{
		int index = get_index(char_in);
		if (index == -1)
		{
			m_char_occ ~= CharacterOccurence(char_in, 0);
		}
		else
		{
			m_char_occ[index].m_occurence++;
		}
	}

	char most_frequent() const
	{
		int max = 0;
		char output;
		foreach(CharacterOccurence occ; m_char_occ)
		{
			if (occ.m_occurence > max)
			{
				max = occ.m_occurence;
				output = occ.m_char;
			}
		}

		return output;
	}
}

string compute_result(string[] inputs)
{
	CharacterOccurenceList[] occurences;

	foreach(ref string line; inputs)
	{
		if (occurences.length < inputs.length)
		{
			occurences = new CharacterOccurenceList[](inputs.length);
		}

		for(int i = 0; i < line.length; i++)
		{
			occurences[i].append(line[i]);
		}
	}

	string output;
	foreach(ref CharacterOccurenceList occurence; occurences)
	{
		output ~= occurence.most_frequent();
	}

	return output;
}
