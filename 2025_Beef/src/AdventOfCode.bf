namespace _2025_Beef;

using System;
using System.Collections;
using System.IO;

class Program
{
	static Result<void> Parse(StringView filePath, List<String> outValues)
	{
		var fs = scope FileStream();
		Try!(fs.Open(filePath));
		for (var lineResult in scope StreamReader(fs).Lines)
		{
			if (lineResult case .Ok(let line))
			{
				let outStr = new String();
				line.ToString(outStr);
				outValues.Add(outStr);
			}
		}
		return .Ok;
	}

	static void Main()
	{
		var fileName = scope String("day06.txt");

		var outValues = scope List<String>();
		Parse(fileName, outValues);

		bool isB = false;
		Day06.Execute(outValues, isB);

		// wait for input and close
		Console.Read();
	}
}