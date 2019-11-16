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

uwu([
            [
                [ 
                    [b, e, b, b],
                    [e, b, e, e],
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
                    [b, e, b, b],
                    [e, e, e, e],
                    [e, w, b, e],
                    [w, e, w, w]
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

%Functions to create a board with variable size

board_size(Board, Size):-
    nth0(0, Board, BoardPair),
    nth0(0, BoardPair, SmallBoard),
    length(SmallBoard, Size).

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
    Board = [[B,B],[B,B]].