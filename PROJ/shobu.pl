:-use_module(library(lists)).

initialBoard([
                [
                    [ 
                        [b, b, b, b],
                        [e, e, e, e],
                        [e, e, e, e],
                        [w, w, w, w]
                    ],
                    [
                        [b, b, b, b],
                        [e, e, e, e],
                        [e, e, e, e],
                        [w, w, w, w]
                    ]
                ],
                [
                    [
                        [b, b, b, b],
                        [e, e, e, e],
                        [e, e, e, e],
                        [w, w, w, w]
                    ],
                    [
                        [b, b, b, b],
                        [e, e, e, e],
                        [e, e, e, e],
                        [w, w, w, w]
                    ]
                ]
            ]).

intermidiateBoard([
                [
                    [ 
                        [e, b, b, b],
                        [e, b, e, e],
                        [e, w, e, e],
                        [w, w, w, e]
                    ],
                    [
                        [b, e, e, b],
                        [e, e, b, b],
                        [e, e, e, e],
                        [w, w, w, e]
                    ]
                ],
                [
                    [
                        [e, b, b, b],
                        [w, e, e, e],
                        [e, e, e, e],
                        [w, w, e, w]
                    ],
                    [
                        [b, b, b, b],
                        [e, e, e, e],
                        [e, w, e, e],
                        [w, e, w, w]
                    ]
                ]
            ]).

endBoard([
                [
                    [ 
                        [e, b, e, b],
                        [e, e, b, b],
                        [e, w, e, e],
                        [w, w, w, e]
                    ],
                    [
                        [b, e, e, b],
                        [e, e, e, b],
                        [e, e, e, e],
                        [e, e, e, b]
                    ]
                ],
                [
                    [
                        [e, w, b, b],
                        [e, e, e, e],
                        [e, e, e, w],
                        [w, e, e, e]
                    ],
                    [
                        [b, b, b, b],
                        [w, e, e, e],
                        [e, w, e, e],
                        [e, e, w, w]
                    ]
                ]
            ]).

symbol(w, S) :-
    S='X'.

symbol(b, S) :-
    S='O'.

symbol(e, S) :-
    S=' '.

printDivisor :-
    write('+---+---+---+---+\t+---+---+---+---+').

printCell(Cell) :-
    write('| '),
    symbol(Cell, Char),
    write(Char),
    write(' ').

printRow([]) :-
    write('|').

printRow([Cell|Rest]) :-
    printCell(Cell),
    printRow(Rest).

printBoardPair(_, 4) :-
    printDivisor.

printBoardPair(BoardPair, N) :-
    nth0(0, BoardPair, Board1),
    nth0(1, BoardPair, Board2),
    nth0(N, Board1, Row1),
    nth0(N, Board2, Row2),
    printDivisor,
    nl,
    printRow(Row1),
    write('\t'),
    printRow(Row2),
    nl,
    N1 is N+1,
    printBoardPair(BoardPair, N1).

printBoard([BP1|[BP2|_]]) :-
    printBoardPair(BP1,0),
    nl,
    write('\no----------------------------------------o\n'),
    nl,
    printBoardPair(BP2,0).

displayGame :-
    intermidiateBoard(Board),
    nl,
    printBoard(Board).
