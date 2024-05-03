:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_server_files)).
:- use_module(library(http/http_client)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- use_module(library(http/http_wrapper)).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_json)).
%import sudoku.pl
:- consult('sudoku.pl').


/*----------------------------------------------------------------
    Pruebas de ejecución
------------------------------------------------------------------*/

hello_world(Greeting) :-
    Greeting = 'Hello, World!'.

navbar(Navbar):-
    Navbar = '---------Prologku---------'.

print_sudoku_text_rows(Output):-
    Output = '_ | _ | _ | _ | _ | _ | _ | _ | _'.


/*----------------------------------------------------------------
    Web server predicates
------------------------------------------------------------------*/

% Establecer la ruta de acceso a los archivos estáticos (por ejemplo, CSS, JavaScript)
:- http_handler(root(static), serve_files_in_directory('static'), [prefix]).

% Definir el manejador para la ruta raíz "/"
:- http_handler(root(.), http_index_handler, []).
:- http_handler(root(sudoku), sudoku_handler, []).
:- http_handler(root(resolve/Sudoku), sudoku_resolve_handler(Method, Sudoku), [method(Method), methods([get]), time_limit(infinite)]).
:- http_handler(root(test), test_handle, []).
:- http_handler(root(api/sudoku/Sudoku), sudoku_api_handler(Method, Sudoku), [method(Method), methods([post])]).

% Manejador para la ruta "/api/sudoku"
sudoku_api_handler(post, Sudoku, Request) :-
    solve_sudoku_solution_string(Sudoku, Solution),
    write("init"),
    write(Solution),
    write("end"),
    reply_json(json([solution=Solution])).


% Manejador para la ruta raíz "/"
http_index_handler(_Request) :-
    reply_html_page(
        title('Ejemplo de Página Web con SWI-Prolog'),
        [ h1('PROLOGKU'),
            p('Bienvenido a prologku!'),
            p('Para iniciar el solucionador de sudoku presiona el botón iniciar:'),
            button([onclick='window.location.href="/sudoku"'], 'Iniciar')
        ]).

/*----------------------------------------------------------------
    prediction with js and prolog
------------------------------------------------------------------*/
js_code(Code):-
    Code = '
    //delete the table if it exists
    let table = document.getElementById("solutionTable");
    if (table) {
        table.remove();
    }
    let size = 9;
    let inputs = document.querySelectorAll("input");
    let plantilla = "";
    for (let i = 0; i < size; i++) {
        let row = "[";
        for (let j = 0; j < size; j++) {
            let index = i * size + j;
            let value = inputs[index].value;
            if (value === "") {
                row += "_";
            } else {
                row += value;
            }
            if (j < size - 1) {
                row += ",";
            }
        }
        row += "]";
        plantilla += row;
        if (i < size - 1) {
            plantilla += ";";
        }
    }
    plantilla = "[" + plantilla + "]";
    //create a new button to send redirect to /resolve/plantilla
    let button = document.createElement("button");
    button.innerHTML = "Resolver";
    button.onclick = async function() {
        //let url = "/resolve/" + JSON.stringify(plantilla);
        //window.location.href = url
        await fetch("/api/sudoku/" + plantilla, {
            method: "POST"
        }).then(response => response.json()).then(data => {
            console.log(data);
            let message = data.message;
            //extraer la solucion que se encuentra entre init y end
            let solution = message.substring(message.indexOf("init") + 4, message.indexOf("end"));
            //alert("Solución: " + solution);
            //imprimir la solucion en la pagina en forma de tabla de 9x9
            let table = document.createElement("table");
            //add id to the table
            table.id = "solutionTable";
            //solution es un string con un array de arrays
            let solutionArray = JSON.parse(solution);
            console.log(solutionArray);
            for (let i = 0; i < size; i++) {
                let row = document.createElement("tr");
                for (let j = 0; j < size; j++) {
                    let cell = document.createElement("td");
                    cell.innerHTML = solutionArray[j][i];
                    row.appendChild(cell);
                }
                table.appendChild(row);
            }
            document.body.appendChild(table);

        }).catch(error => {
            console.error("Error:", error);
        });
    }
    document.body.appendChild(button);'.

% Manejador para la ruta "/test con parametro test imprimiendo el parametro"
test_handle(Request) :-
    member(search(Search), Request),
    member(test=String, Search),
    reply_html_page(
        title('PROLOGKU'),
        [ h1('PROLOGKU'),
            p('Test:'),
            p(String),
            button([onclick='window.location.href="/sudoku"'], 'Regresar')
        ]).


% Manejador para la ruta "/resolve"
sudoku_resolve_handler(get, Sudoku, _Request) :-
    copy_term(Sudoku, SudokuCopy),  % Crear una copia de Sudoku
    solve_sudoku_solution_string(SudokuCopy, Solution),
    write(Solution),
    reply_sudoku_solution(Solution).

% Predicado para responder con la solución del sudoku
reply_sudoku_solution(Solution) :-
    reply_html_page(
        title('PROLOGKU'),
        [ h1('PROLOGKU'),
          p('Resuelto:'),
          p(Solution),  % Mostrar la solución obtenida
          button([onclick='window.location.href="/sudoku"'], 'Regresar')
        ]).

% Manejador para la ruta "/sudoku"
sudoku_handler(_Request) :-
    hello_world(Output),
    navbar(Navbar),
    js_code(Js),
    print_sudoku_text_rows(Row),
    reply_html_page(
        title('PROLOGKU'),
        [ h1('PROLOGKU'),
            table([],
                [ tr([], [ 
                            td([], 
                                [
                                    input([type='number', id='input_1', placeholder='0']), 
                                    input([type='number', id='input_2', placeholder='0']),
                                    input([type='number', id='input_3', placeholder='0']),
                                    input([type='number', id='input_4', placeholder='0']),
                                    input([type='number', id='input_5', placeholder='0']),
                                    input([type='number', id='input_6', placeholder='0']),
                                    input([type='number', id='input_7', placeholder='0']),
                                    input([type='number', id='input_8', placeholder='0']),
                                    input([type='number', id='input_9', placeholder='0'])]),
                            td([], 
                                [
                                    input([type='number', id='input_10', placeholder='0']), 
                                    input([type='number', id='input_11', placeholder='0']),
                                    input([type='number', id='input_12', placeholder='0']),
                                    input([type='number', id='input_13', placeholder='0']),
                                    input([type='number', id='input_14', placeholder='0']),
                                    input([type='number', id='input_15', placeholder='0']),
                                    input([type='number', id='input_16', placeholder='0']),
                                    input([type='number', id='input_17', placeholder='0']),
                                    input([type='number', id='input_18', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_19', placeholder='0']), 
                                    input([type='number', id='input_20', placeholder='0']),
                                    input([type='number', id='input_21', placeholder='0']),
                                    input([type='number', id='input_22', placeholder='0']),
                                    input([type='number', id='input_23', placeholder='0']),
                                    input([type='number', id='input_24', placeholder='0']),
                                    input([type='number', id='input_25', placeholder='0']),
                                    input([type='number', id='input_26', placeholder='0']),
                                    input([type='number', id='input_27', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_28', placeholder='0']), 
                                    input([type='number', id='input_29', placeholder='0']),
                                    input([type='number', id='input_30', placeholder='0']),
                                    input([type='number', id='input_31', placeholder='0']),
                                    input([type='number', id='input_32', placeholder='0']),
                                    input([type='number', id='input_33', placeholder='0']),
                                    input([type='number', id='input_34', placeholder='0']),
                                    input([type='number', id='input_35', placeholder='0']),
                                    input([type='number', id='input_36', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_37', placeholder='0']), 
                                    input([type='number', id='input_38', placeholder='0']),
                                    input([type='number', id='input_39', placeholder='0']),
                                    input([type='number', id='input_40', placeholder='0']),
                                    input([type='number', id='input_41', placeholder='0']),
                                    input([type='number', id='input_42', placeholder='0']),
                                    input([type='number', id='input_43', placeholder='0']),
                                    input([type='number', id='input_44', placeholder='0']),
                                    input([type='number', id='input_45', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_46', placeholder='0']), 
                                    input([type='number', id='input_47', placeholder='0']),
                                    input([type='number', id='input_48', placeholder='0']),
                                    input([type='number', id='input_49', placeholder='0']),
                                    input([type='number', id='input_50', placeholder='0']),
                                    input([type='number', id='input_51', placeholder='0']),
                                    input([type='number', id='input_52', placeholder='0']),
                                    input([type='number', id='input_53', placeholder='0']),
                                    input([type='number', id='input_54', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_55', placeholder='0']), 
                                    input([type='number', id='input_56', placeholder='0']),
                                    input([type='number', id='input_57', placeholder='0']),
                                    input([type='number', id='input_58', placeholder='0']),
                                    input([type='number', id='input_59', placeholder='0']),
                                    input([type='number', id='input_60', placeholder='0']),
                                    input([type='number', id='input_61', placeholder='0']),
                                    input([type='number', id='input_62', placeholder='0']),
                                    input([type='number', id='input_63', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_64', placeholder='0']), 
                                    input([type='number', id='input_65', placeholder='0']),
                                    input([type='number', id='input_66', placeholder='0']),
                                    input([type='number', id='input_67', placeholder='0']),
                                    input([type='number', id='input_68', placeholder='0']),
                                    input([type='number', id='input_69', placeholder='0']),
                                    input([type='number', id='input_70', placeholder='0']),
                                    input([type='number', id='input_71', placeholder='0']),
                                    input([type='number', id='input_72', placeholder='0'])]),
                            td([],
                                [
                                    input([type='number', id='input_73', placeholder='0']), 
                                    input([type='number', id='input_74', placeholder='0']),
                                    input([type='number', id='input_75', placeholder='0']),
                                    input([type='number', id='input_76', placeholder='0']),
                                    input([type='number', id='input_77', placeholder='0']),
                                    input([type='number', id='input_78', placeholder='0']),
                                    input([type='number', id='input_79', placeholder='0']),
                                    input([type='number', id='input_80', placeholder='0']),
                                    input([type='number', id='input_81', placeholder='0'])])

                ]),
            button([onclick=Js], "Check")
        ])]).

% Predicado principal para iniciar el servidor
main(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Iniciar el servidor en el puerto 8000
:- initialization(main(8000)).
