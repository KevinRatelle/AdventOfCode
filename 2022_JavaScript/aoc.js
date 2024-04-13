import {compute_result} from "./day1.js"

import * as fs from 'fs';

fs.readFile('day1.txt', (err, inputD) =>
{
	if (err) throw err;

	let is_part_b = true;
	var result = compute_result(inputD.toString(), is_part_b);

	console.log(result);
 })