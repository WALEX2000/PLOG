:-use_module(library(lists)).
:-consult('boards.pl').
:-consult('display.pl').
:-consult('logic.pl').
:-consult('input.pl').

play() :-
    initialBoard(Board),
    playHvsH(Board).

playHvsH(InitBoard) :-
    %%CHECK GAME OVER
    gameOver(InitBoard), printBoard(InitBoard, 1);

    %%PLAYER 1 FIRST MOVE%%
    display_game(InitBoard, 1, 1),
    valid_moves(InitBoard, b|1, Player1FirstMoves),
    repeat,
    getPlayerMove(OrigLineP1M1, OrigColP1M1, DestLineP1M1, DestColP1M1, Player1FirstMoves, _),
    move(InitBoard, BoardPostP1First, OrigLineP1M1, OrigColP1M1, DestLineP1M1, DestColP1M1),!,  

    %%PLAYER 1 SECOND MOVE%%
    display_game(BoardPostP1First, 1, 2),
    valid_moves(BoardPostP1First, b|2, [OrigLineP1M1/OrigColP1M1,DestLineP1M1/DestColP1M1], Player1SecondMoves),
    repeat,
    getPlayerMove(OrigLineP1M2, OrigColP1M2, DestLineP1M2, DestColP1M2, Player1SecondMoves, PiecePushed1),
    pushPiece(BoardPostP1First, BoardPostP1Push, PiecePushed1),!,
    move(BoardPostP1Push, BoardPostP1Second, OrigLineP1M2, OrigColP1M2, DestLineP1M2, DestColP1M2),!,

    %%CHECK GAME OVER
    (gameOver(BoardPostP1Second), printBoard(BoardPostP1Second, 1);

    %%PLAYER 2 FIRST MOVE%%
    display_game(BoardPostP1Second, 2, 1),
    valid_moves(BoardPostP1Second, w|1, Player2FirstMoves),
    repeat,
    getPlayerMove(OrigLineP2M1, OrigColP2M1, DestLineP2M1, DestColP2M1, Player2FirstMoves, _),
    move(BoardPostP1Second, BoardPostP2First, OrigLineP2M1, OrigColP2M1, DestLineP2M1, DestColP2M1),!,

    %%PLAYER 2 SECOND MOVE%%
    display_game(BoardPostP2First, 2, 2),
    valid_moves(BoardPostP2First, w|2, [OrigLineP2M1/OrigColP2M1,DestLineP2M1/DestColP2M1], Player2SecondMoves),
    repeat,
    getPlayerMove(OrigLineP2M2, OrigColP2M2, DestLineP2M2, DestColP2M2, Player2SecondMoves, PiecePushed2),
    pushPiece(BoardPostP2First, BoardPostP2Push, PiecePushed2),!,
    move(BoardPostP2Push, BoardPostP2Second, OrigLineP2M2, OrigColP2M2, DestLineP2M2, DestColP2M2),!,

    %%NEXT TURN
    playHvsH(BoardPostP2Second)).

