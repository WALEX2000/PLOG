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

symbol(whitePiece, S) :-
    S='W'.

symbol(blackPiece, S) :-
    S='B'.

symbol(emptyCell, S) :-
    S=' '.

printGame([]).

printGame([BoardPair | Rest]) :-
    nl,
    write('   | 1 | 2 | 3 | 4 | 5 |\t| 6 | 7 | 8 | 9 | 10|\n'),
    write('---|---|---|---|---|---|\t|---|---|---|---|---|\n'),
    printBoardPair(BoardPair, 0),
    printGame(Rest).

printBoardPair(_, 4) :-
    nl.

printBoardPair([Board1 | [Board2 | _]], N) :-
    printLine([_ | [_ | Board1]], [_ | [_ | Board2]]),
    nl,
    N1 is N + 1,
    printBoardPair([Board1 | [Board2 | _]], N1).

printLine([], []).
printLine([], [Element2 | Line2]) :-
    symbol(Element2, S),
    write(S),
    printLine([], Line2).
printLine([Element1 | Line1], _) :-
    symbol(Element1, S),
    write(S),
    printLine(Line1, _).