:-use_module(library(lists)).
:-consult('display.pl').
:-consult('logic.pl').
:-consult('input.pl').

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
                        [e, b, e, b],
                        [e, b, b, e],
                        [w, e, e, e],
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
    

play() :-
    initialBoard(Board),
    display_game(Board, 1),
    valid_moves(Board, 1, _).

test() :-
    initialBoard(Board1),
    display_game(Board1, 1),!,
    move(Board1, Board2, 0, 0, 1, 1),
    display_game(Board2, 1),!,
    move(Board2, Board3, 7, 7, 6, 7),
    display_game(Board3, 2),!.

test2() :-
    readPlay(Line, Col, 3),
    write(Line),
    write('\n'),
    write(Col).

%Functions to create a board with variable size

createList(0, _, []).
createList(Size, Char, [Char|Rest]):-
    N is Size - 1,
    createList(N, Char, Rest).

fillSmallBoard(B, Size, Size):-
    createList(Size, 'b', Blist),
    B = [Blist|Rest], N is Size - 1,
    fillSmallBoard(Rest, Size, N).

fillSmallBoard([Elem], Size, 1):-
    createList(Size, 'w', Wlist),
    Elem = Wlist.

fillSmallBoard([Elem|Rest], Size, N):-
    createList(Size, 'e', Elist),
    Elem = Elist, N1 is N - 1,
    fillSmallBoard(Rest, Size, N1).

createSmallBoard(B, Size):-
    fillSmallBoard(B, Size, Size).

createBoard(Size, Board):-
    createSmallBoard(B, Size),
    Board = [[B,B],[B,B]],
    display_game(Board, 1).

testValidPos(Moves):-
    %createBoard(4, Board),
    intermediateBoard(Board), 
    display_game(Board, 1),
    valid_moves(Board, b|1, Moves).

testValidPos2(Moves):-
    %createBoard(4, Board),
    intermediateBoard(Board), 
    display_game(Board, 1),
    valid_moves(Board, w|2, [7/6, 6/7], Moves), notrace.
