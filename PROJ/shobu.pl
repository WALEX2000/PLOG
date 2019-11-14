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
    write('\e[H\e[2J'),
    display_game(InitBoard, 1),
    valid_moves(InitBoard, b|1, Player1FirstMoves),
    repeat,
    (
        write("Origin (eg: A1):"),
        readCell(OrigLineP1M1, OrigColP1M1, 4),
        write("Destination (eg: A1):"),
        readCell(DestLineP1M1, DestColP1M1, 4),
        member([OrigLineP1M1/OrigColP1M1,DestLineP1M1/DestColP1M1], Player1FirstMoves);
        write("Invalid move.\n"),
        fail
    ),
    move(InitBoard, BoardPostP1First, OrigLineP1M1, OrigColP1M1, DestLineP1M1, DestColP1M1),
    write('\e[H\e[2J'),
    display_game(BoardPostP1First, 1),
    valid_moves(BoardPostP1First, b|2, [OrigLineP1M1/OrigColP1M1,DestLineP1M1/DestColP1M1], Player1SecondMoves),
    repeat,
    (
        write("Origin (eg: A1):"),
        readCell(OrigLineP1M2, OrigColP1M2, 4),
        write("Destination (eg: A1):"),
        readCell(DestLineP1M2, DestColP1M2, 4),
        member([[OrigLineP1M2/OrigColP1M2,DestLineP1M2/DestColP1M2],_], Player1SecondMoves);
        write("Invalid move.\n"),
        fail
    ),
    move(BoardPostP1First, BoardPostP1Second, OrigLineP1M2, OrigColP1M2, DestLineP1M2, DestColP1M2),!,
    (gameOver(BoardPostP1Second);
    write('\e[H\e[2J'),
    display_game(BoardPostP1Second, 2),
    valid_moves(BoardPostP1Second, w|1, Player2FirstMoves),
    repeat,
    (
        write("Origin (eg: A1):"),
        readCell(OrigLineP2M1, OrigColP2M1, 4),
        write("Destination (eg: A1):"),
        readCell(DestLineP2M1, DestColP2M1, 4),
        member([OrigLineP2M1/OrigColP2M1,DestLineP2M1/DestColP2M1], Player2FirstMoves);
        write("Invalid move.\n"),
        fail
    ),
    move(BoardPostP1Second, BoardPostP2First, OrigLineP2M1, OrigColP2M1, DestLineP2M1, DestColP2M1),
    write('\e[H\e[2J'),
    display_game(BoardPostP2First, 2),
    valid_moves(BoardPostP2First, w|2, [OrigLineP2M1/OrigColP2M1,DestLineP2M1/DestColP2M1], Player2SecondMoves),
    repeat,
    (
        write("Origin (eg: A1):"),
        readCell(OrigLineP2M2, OrigColP2M2, 4),
        write("Destination (eg: A1):"),
        readCell(DestLineP2M2, DestColP2M2, 4),
        member([[OrigLineP2M2/OrigColP2M2,DestLineP2M2/DestColP2M2],_], Player2SecondMoves);
        write("Invalid move.\n"),
        fail
    ),
    move(BoardPostP2First, FinalBoard, OrigLineP2M2, OrigColP2M2, DestLineP2M2, DestColP2M2),
    playHvsH(FinalBoard)).

test() :-
    initialBoard(Board1),
    display_game(Board1, 1),!,
    move(Board1, Board2, 0, 0, 1, 1),
    display_game(Board2, 1),!,
    move(Board2, Board3, 7, 7, 6, 7),
    display_game(Board3, 2),!.
