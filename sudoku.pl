:- use_module(library(clpfd)).
:- use_module(library(random)).

solve_sudoku(Rows, Output) :-
    % Validate length of rows and columns
	length(Rows, 9),
    maplist(same_length(Rows), Rows),

    % Validate elements within 1 to 9
	append(Rows, Vs),
    Vs ins 1..9,

    % Validate all distinct elements within same row
	maplist(all_distinct, Rows),

    % Transpose the sudoku to be able to apply the all_distinct
    % predicate in an easy way
	transpose(Rows, Columns),
    % Validate all distinct elements within same column
    maplist(all_distinct, Columns),

    % Validate each block on a 3 by 3 basis due to the
    % block size 
	Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is],
	validate_blocks(As, Bs, Cs), validate_blocks(Ds, Es, Fs), validate_blocks(Gs, Hs, Is),

    % With the given rules above, the label predicate will fill
    % the values within the rows that match them.
	maplist(label, Rows),

    Output = Rows.

validate_blocks([], [], []).
validate_blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
	all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
	validate_blocks(Ns1, Ns2, Ns3).

% Ejemplo de consulta para resolver un sudoku
% solve_sudoku([[5,3,_,_,7,_,_,_,_],[6,_,_,1,9,5,_,_,_],[_,9,8,_,_,_,_,6,_],[8,_,_,_,6,_,_,_,3],[4,_,_,8,_,3,_,_,1],[7,_,_,_,2,_,_,_,6],[_,6,_,_,_,_,2,8,_],[_,_,_,4,1,9,_,_,5],[_,_,_,_,8,_,_,7,9]], Solution).

% Nota: En la consulta de ejemplo, los guiones bajos (_) representan las celdas vacías del sudoku.
solve_sudoku_solution_string("", Output):-
    solve_sudoku([[]], Output).

%input example "[[5,3,_,_,7,_,_,_,_],[6,_,_,1,9,5,_,_,_],[_,9,8,_,_,_,_,6,_],[8,_,_,_,6,_,_,_,3],[4,_,_,8,_,3,_,_,1],[7,_,_,_,2,_,_,_,6],[_,6,_,_,_,_,2,8,_],[_,_,_,4,1,9,_,_,5],[_,_,_,_,8,_,_,7,9]]"
solve_sudoku_solution_string(Rows_string, Output) :-
    string_list_to_list(Rows_string, Rows),
    write(Rows),
    solve_sudoku(Rows, Output).

% Predicado para convertir una cadena de Sudoku en una lista de listas
string_list_to_list(String, List) :-
    % Eliminar los corchetes externos del String para obtener solo el contenido
    sub_string(String, 1, _, 1, ContentTrimmed),
    % Dividir el contenido en sublistas utilizando el delimitador ';'
    split_string(ContentTrimmed, ";", "", Sublists),
    % Convertir cada sublista de cadena a una lista de números o guiones bajos
    maplist(string_to_list_of_numbers, Sublists, List).

% Predicado para convertir una cadena de lista en una lista de elementos
string_to_list_of_numbers(String, List) :-
    % Remover los corchetes al principio y al final de la cadena
    sub_string(String, 1, _, 1, Trimmed),
    % Dividir la cadena en elementos separados por comas
    split_string(Trimmed, ",", "[]", Elements),
    % Convertir cada elemento en un número o dejarlo como _
    maplist(atom_to_number_or_underscore, Elements, List).

% Predicado para convertir un átomo en un número o mantenerlo como un guion bajo
atom_to_number_or_underscore(Atom, Number) :-
    % Si el átomo es "_", devolverlo tal cual
    Atom == "_" -> Number = _;
    % De lo contrario, convertir el átomo en un número
    atom_number(Atom, Number).

%trace, (solve_sudoku_solution_string("[[5,3,_,_,7,_,_,_,_];[6,_,_,1,9,5,_,_,_];[_,9,8,_,_,_,_,6,_];[8,_,_,_,6,_,_,_,3];[4,_,_,8,_,3,_,_,1];[7,_,_,_,2,_,_,_,6];[_,6,_,_,_,_,2,8,_];[_,_,_,4,1,9,_,_,5];[_,_,_,_,8,_,_,7,9]]", Solution)).