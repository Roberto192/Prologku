:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/html_write)).
:- use_module(library(http/http_server_files)).
:- use_module(library(clpfd)).
:- use_module(library(random)).


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

% Manejador para la ruta raíz "/"
http_index_handler(_Request) :-
    reply_html_page(
        title('Ejemplo de Página Web con SWI-Prolog'),
        [ h1('PROLOGKU'),
            p('Bienvenido a prologku!'),
            p('Para iniciar el solucionador de sudoku presiona el botón iniciar:'),
            button([onclick='window.location.href="/sudoku"'], 'Iniciar')
        ]).

% Manejador para la ruta "/sudoku"
sudoku_handler(_Request) :-
    hello_world(Output),
    navbar(Navbar),
    print_sudoku_text_rows(Row),
    reply_html_page(
        title('PROLOGKU'),
        [ h1('PROLOGKU'),
            table([],
                [ tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                    tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ]),
                        tr([], [ td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])]),
                            td([], 
                            [input([type='number', id='input', placeholder='0'])])
                        ])
                ]),
            input([type='text', id='input', placeholder='Ingresa ("resolver" | FILA,COLUMNA,VALOR)'],
                []),
            button([onclick="console.log('Hola')"], "Check"),
            button([onclick='window.location.href="/"'], 'Regresar')
        ]).

% Predicado principal para iniciar el servidor
main(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Iniciar el servidor en el puerto 8000
:- initialization(main(8000)).
