
export function compute_result(data)
{
	const inputs = data.split(/\r?\n|\r|\n/g);

	let maximum = 0;
	let current_sum = 0;

	for (let i = 0; i < inputs.length; i++)
	{
		let input = inputs[i];
		if (input.length == 0)
		{
			if (current_sum > maximum)
			{
				maximum = current_sum;
			}
			current_sum = 0;
		}
		else
		{
			let val = parseInt(input);
			current_sum += val;
		}
	}

	return maximum;
}