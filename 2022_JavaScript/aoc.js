import {compute_result} from "./day1.js"

import * as fs from 'fs';

fs.readFile('day1.txt', (err, inputD) =>
{
	if (err) throw err;

	var result = compute_result(inputD.toString());

	console.log(result);
 })