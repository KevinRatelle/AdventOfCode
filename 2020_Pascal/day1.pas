unit day1;

interface
uses Sysutils;

function compute_result(var f :  TextFile): longint;

implementation
function compute_result(var f :  TextFile): longint;

const
	searched_value = 2020;

var
	m: string;
	inputs: array of integer;
	i: integer;
	j: integer;
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
			if inputs[i] + inputs[j] = searched_value then
			begin
			compute_result := inputs[i] * inputs[j];
				found := true;
			end;

			if found then
				break;
		end;

		if found then
			break;
	end;

end;

end.