:- use_module(library(clpfd)).
:- use_module(library(random)).

% Define el tamaño del sudoku (normalmente es 9x9)
sudoku_size(9).

% Predicado para resolver el sudoku
solve_sudoku_solution(Rows, Output) :-
    sudoku_size(N),
    length(Rows, N),  % Asegura que Rows tiene N filas
    maplist(same_length(Rows), Rows),  % Asegura que todas las filas tengan la misma longitud

    % Flattening para obtener una lista de celdas
    append(Rows, Cells),  
    Cells ins 1..N,  % Las celdas contienen valores entre 1 y N

    % Restricciones de filas, columnas y cuadrados
    maplist(all_distinct, Rows),  % Todas las filas deben contener valores distintos
    transpose(Rows, Columns),     % Transpone Rows para obtener las columnas
    maplist(all_distinct, Columns),  % Todas las columnas deben contener valores distintos

    % Definir las restricciones para los bloques 3x3
    define_blocks(Rows, Output),
    
    % Llama al predicado labeling para buscar una solución
    labeling([ffc], Cells).  % ffc significa 'first-fail' para etiquetar las variables más restringidas primero

% Define las restricciones para los bloques 3x3
define_blocks(Rows, Output) :-
    blocks(Rows, Blocks),  % Obtiene los bloques 3x3 del sudoku
    maplist(all_distinct, Blocks),  % Asegura que todos los bloques contengan valores distintos
    flatten(Blocks, Output).  % Aplana los bloques para obtener la salida final

% Obtiene los bloques 3x3 del sudoku
blocks([], []).
blocks([A,B,C|Rows], Blocks) :-
    blocks_of_three(A, B, C, Block),
    blocks(Rows, RestBlocks),
    append(Block, RestBlocks, Blocks).

% Divide cada fila en bloques de tres celdas
blocks_of_three([], [], [], []).
blocks_of_three([A,B,C|Row1], [D,E,F|Row2], [G,H,I|Row3], [[A,B,C,D,E,F,G,H,I]|Blocks]) :-
    blocks_of_three(Row1, Row2, Row3, Blocks).

% Ejemplo de consulta para resolver un sudoku
% solve_sudoku_solution([[5,3,_,_,7,_,_,_,_],[6,_,_,1,9,5,_,_,_],[_,9,8,_,_,_,_,6,_],[8,_,_,_,6,_,_,_,3],[4,_,_,8,_,3,_,_,1],[7,_,_,_,2,_,_,_,6],[_,6,_,_,_,_,2,8,_],[_,_,_,4,1,9,_,_,5],[_,_,_,_,8,_,_,7,9]], Solution).

% Nota: En la consulta de ejemplo, los guiones bajos (_) representan las celdas vacías del sudoku.
