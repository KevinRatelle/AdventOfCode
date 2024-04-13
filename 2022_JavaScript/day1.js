
export function compute_result(data, is_part_b)
{
	const inputs = data.split(/\r?\n|\r|\n/g);

	let maximum = [0];

	if (is_part_b)
	{
		maximum.push(0, 0);
	}

	console.log(maximum);

	let current_sum = 0;

	for (let i = 0; i < inputs.length; i++)
	{
		let input = inputs[i];
		if (input.length == 0)
		{
			if (current_sum > maximum[0])
			{
				maximum[0] = current_sum;
				maximum.sort(function(a, b) {return a - b;});
				console.log(maximum);
			}

			current_sum = 0;
		}
		else
		{
			let val = parseInt(input);
			current_sum += val;
		}
	}

	let sum = 0;
	maximum.forEach(item =>
	{
		sum += item;
	});

	return sum;
}