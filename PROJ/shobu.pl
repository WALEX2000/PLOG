:-use_module(library(lists)).

initialBoard([
                [
                    [ 
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ],
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ]
                ],
                [
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ],
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ]
                ]
            ]).

endBoard([
                [
                    [ 
                        [whitePiece, emptyCell, emptyCell, whitePiece],
                        [whitePiece, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, whitePiece],
                        [blackPiece, emptyCell, blackPiece, blackPiece]
                    ],
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ]
                ],
                [
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ],
                    [
                        [whitePiece, whitePiece, whitePiece, whitePiece],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [emptyCell, emptyCell, emptyCell, emptyCell],
                        [blackPiece, blackPiece, blackPiece, blackPiece]
                    ]
                ]
            ]).


symbol(whitePiece, S) :-
    S='X'.

symbol(blackPiece, S) :-
    S='O'.

symbol(emptyCell, S) :-
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
    nl, nl,
    write('-----------------------------------------'),
    nl, nl,
    printBoardPair(BP2,0).

displayGame(Board) :-
    printBoard(Board).
