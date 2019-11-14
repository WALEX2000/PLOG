:-use_module(library(lists)).
:-consult('boards.pl').
:-consult('display.pl').
:-consult('logic.pl').
:-consult('input.pl').

play() :-
    initialBoard(Board),
    playHvsH(Board).

playHvsH(InitBoard) :-
    gameOver(InitBoard);
    display_game(InitBoard, 1),
    repeat,
    write("Origin (eg: A1):"),
    readPlay(OrigLine1, OrigCol1, 4),
    !,
    repeat,
    write("Destination (eg: A1):"),
    readPlay(DestLine1, DestCol1, 4),
    !,
    move(InitBoard, MidBoard, OrigLine1, OrigCol1, DestLine1, DestCol1),!,
    (gameOver(MidBoard);
    display_game(MidBoard, 2),
    repeat,
    write("Origin (eg: A1):"),
    readPlay(OrigLine2, OrigCol2, 4),
    repeat,
    write("Destination (eg: A1):"),
    readPlay(DestLine2, DestCol2, 4),
    move(MidBoard, FinalBoard, OrigLine2, OrigCol2, DestLine2, DestCol2),!,
    playHvsH(FinalBoard)).

test() :-
    initialBoard(Board1),
    display_game(Board1, 1),!,
    move(Board1, Board2, 0, 0, 1, 1),
    display_game(Board2, 1),!,
    move(Board2, Board3, 7, 7, 6, 7),
    display_game(Board3, 2),!.

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
