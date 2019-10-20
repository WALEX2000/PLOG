:-use_module(library(lists)).
encoding('UTF-8').

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

intermediateBoard([
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
    S='⛂'.

symbol(b, S) :-
    S='⛀'.

symbol(e, S) :-
    S=' '.

printTopDivisor:-
    write('  ╔═══╦═══╦═══╦═══╗\t╔═══╦═══╦═══╦═══╗').
printMidDivisor :-
    write('  ╠═══╬═══╬═══╬═══╣\t╠═══╬═══╬═══╬═══╣').
printBotDivisor :-
    write('  ╚═══╩═══╩═══╩═══╝\t╚═══╩═══╩═══╩═══╝').

printDivisor(3) :-
    printBotDivisor.
printDivisor(_) :-
    printMidDivisor.

printCell(Cell) :-
    write('║ '),
    symbol(Cell, Char),
    write(Char),
    write(' ').

printRow([]) :-
    write('║').
printRow([Cell|Rest]) :-
    printCell(Cell),
    printRow(Rest).

letter(0, 0, L) :- L='A'.
letter(1, 0, L) :- L='B'.
letter(2, 0, L) :- L='C'.
letter(3, 0, L) :- L='D'.
letter(0, 1, L) :- L='E'.
letter(1, 1, L) :- L='F'.
letter(2, 1, L) :- L='G'.
letter(3, 1, L) :- L='H'.

printBoardPair(_, 4, _).
printBoardPair(BoardPair, NRow, NBoard) :-
    nth0(0, BoardPair, Board1),
    nth0(1, BoardPair, Board2),
    nth0(NRow, Board1, Row1),
    nth0(NRow, Board2, Row2),
    nl,
    letter(NRow, NBoard, Letter),
    write(Letter),
    write(' '),
    printRow(Row1),
    write('\t'),
    printRow(Row2),
    nl,
    printDivisor(NRow),
    N1 is NRow+1,
    printBoardPair(BoardPair, N1, NBoard).

printColumnIDs :-
    write('    1   2   3   4         5   6   7   8\n').

printBoardsSeparator :-
    nl,
    write('  .-.-.   .-.-.   .-.-.   .-.-.   .-.-.  \n'),
    write(' / / \\ \\ / / \\ \\ / / \\ \\ / / \\ \\ / / \\ \\\n'),
    write('\`-\'   \`-\`-\'   \`-\`-\'   \`-\`-\'   \`-\`-\'   \`-\`-\'\n'),
    nl.

printBoard([BP1|[BP2|_]]) :-
    printColumnIDs,
    printTopDivisor,
    printBoardPair(BP1,0, 0),
    printBoardsSeparator,
    printTopDivisor,
    printBoardPair(BP2,0, 1).

display_game(Board, Player) :-
    nl,
    write('Player '),
    write(Player),
    write(' playing:\n'),
    nl,
    printBoard(Board).
