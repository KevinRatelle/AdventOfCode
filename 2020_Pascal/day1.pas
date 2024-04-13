unit day1;

interface
uses Sysutils;

function compute_result(var f:  TextFile; is_part_b: boolean): longint;

implementation
function compute_result(var f :  TextFile; is_part_b: boolean): longint;

const
	searched_value = 2020;

var
	m: string;
	inputs: array of integer;
	i, j, k: integer;
	found: boolean;

begin
	i := 0;
	found := false;

	while not eof(f) do
	begin
		ReadLn(f, m);
		SetLength(inputs, i + 1);
		inputs[i] := StrToInt(m);
		i := i + 1;
	end;

	(* loop through all items to find the matching pair *)
	for i := low(inputs) to high(inputs) do
	begin
		for j := i+1 to high(inputs) do
		begin
			if is_part_b then
			begin
				for k := j+1 to high(inputs) do
				begin
					if inputs[i] + inputs[j] + inputs[k] = searched_value then
					begin
						compute_result := inputs[i] * inputs[j] * inputs[k];
						found := true;
					end;

					if found then
						break;
				end;
			end
			else
			begin
				if inputs[i] + inputs[j] = searched_value then
				begin
					compute_result := inputs[i] * inputs[j];
					found := true;
				end;
			end;

			if found then
				break;
		end;

		if found then
			break;
	end;

end;

end.