:-use_module(library(lists)).
:-consult('boards.pl').
:-consult('display.pl').
:-consult('logic.pl').
:-consult('input.pl').

play() :-
    initialBoard(Board),
    %playHvsH(Board).
    %playHvsM(Board,0).
    playMvsM(Board,0,0).

playHvsH(InitBoard) :-
    %%CHECK GAME OVER
    gameOver(InitBoard, Winner), printBoard(InitBoard, Winner);

    %%PLAYER 1 FIRST MOVE%%
    display_game(InitBoard, 1, 1),
    valid_moves(InitBoard, b|1, Player1FirstMoves),
    repeat,
    getPlayerMove(OrigLineP1M1, OrigColP1M1, DestLineP1M1, DestColP1M1, Player1FirstMoves, _),
    move([OrigLineP1M1/OrigColP1M1, DestLineP1M1/DestColP1M1], InitBoard, BoardPostP1First),!,  

    %%PLAYER 1 SECOND MOVE%%
    display_game(BoardPostP1First, 1, 2),
    valid_moves(BoardPostP1First, b|2, [OrigLineP1M1/OrigColP1M1,DestLineP1M1/DestColP1M1], Player1SecondMoves),
    repeat,
    getPlayerMove(OrigLineP1M2, OrigColP1M2, DestLineP1M2, DestColP1M2, Player1SecondMoves, PiecePushed1),
    pushPiece(BoardPostP1First, BoardPostP1Push, PiecePushed1),!,
    move([OrigLineP1M2/OrigColP1M2, DestLineP1M2/DestColP1M2], BoardPostP1Push, BoardPostP1Second),!,

    %%CHECK GAME OVER
    (gameOver(BoardPostP1Second, Winner), printBoard(BoardPostP1Second, Winner);

    %%PLAYER 2 FIRST MOVE%%
    display_game(BoardPostP1Second, 2, 1),
    valid_moves(BoardPostP1Second, w|1, Player2FirstMoves),
    repeat,
    getPlayerMove(OrigLineP2M1, OrigColP2M1, DestLineP2M1, DestColP2M1, Player2FirstMoves, _),
    move([OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1], BoardPostP1Second, BoardPostP2First),!,

    %%PLAYER 2 SECOND MOVE%%
    display_game(BoardPostP2First, 2, 2),
    valid_moves(BoardPostP2First, w|2, [OrigLineP2M1/OrigColP2M1,DestLineP2M1/DestColP2M1], Player2SecondMoves),
    repeat,
    getPlayerMove(OrigLineP2M2, OrigColP2M2, DestLineP2M2, DestColP2M2, Player2SecondMoves, PiecePushed2),
    pushPiece(BoardPostP2First, BoardPostP2Push, PiecePushed2),!,
    move([OrigLineP2M2/OrigColP2M2, DestLineP2M2/DestColP2M2], BoardPostP2Push, BoardPostP2Second),!,

    %%NEXT TURN
    playHvsH(BoardPostP2Second)).

playHvsM(InitBoard, DifficultyBot) :-
    %%CHECK GAME OVER
    gameOver(InitBoard, Winner), printBoard(InitBoard, Winner);

    %%PLAYER 1 FIRST MOVE%%
    display_game(InitBoard, 1, 1),
    valid_moves(InitBoard, b|1, Player1FirstMoves),
    repeat,
    getPlayerMove(OrigLineP1M1, OrigColP1M1, DestLineP1M1, DestColP1M1, Player1FirstMoves, _),
    move([OrigLineP1M1/OrigColP1M1, DestLineP1M1/DestColP1M1], InitBoard, BoardPostP1First),!,  

    %%PLAYER 1 SECOND MOVE%%
    display_game(BoardPostP1First, 1, 2),
    valid_moves(BoardPostP1First, b|2, [OrigLineP1M1/OrigColP1M1,DestLineP1M1/DestColP1M1], Player1SecondMoves),
    repeat,
    getPlayerMove(OrigLineP1M2, OrigColP1M2, DestLineP1M2, DestColP1M2, Player1SecondMoves, PiecePushed1),
    pushPiece(BoardPostP1First, BoardPostP1Push, PiecePushed1),!,
    move([OrigLineP1M2/OrigColP1M2, DestLineP1M2/DestColP1M2], BoardPostP1Push, BoardPostP1Second),!,

    %%CHECK GAME OVER
    (gameOver(BoardPostP1Second, Winner), printBoard(BoardPostP1Second, Winner);

    %%PLAYER 2 FIRST MOVE%%
    display_game(BoardPostP1Second, 2, 1),!,
    choose_move(BoardPostP1Second, DifficultyBot, w|1, [OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1]),
    move([OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1], BoardPostP1Second, BoardPostP2First),!,

    %%PLAYER 2 SECOND MOVE%%
    display_game(BoardPostP2First, 2, 2),!,
    choose_move(BoardPostP1Second, DifficultyBot, w|2, [OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1], [[OrigLineP2M2/OrigColP2M2, DestLineP2M2/DestColP2M2],PiecePushed2]),
    pushPiece(BoardPostP2First, BoardPostP2Push, PiecePushed2),!,
    move([OrigLineP2M2/OrigColP2M2, DestLineP2M2/DestColP2M2], BoardPostP2Push, BoardPostP2Second),!,

    %%NEXT TURN
    playHvsM(BoardPostP2Second, DifficultyBot)).

playMvsM(InitBoard, DifficultyBot1, DifficultyBot2) :-
    %%CHECK GAME OVER
    gameOver(InitBoard, Winner), printBoard(InitBoard, Winner);

    %%PLAYER 1 FIRST MOVE%%
    display_game(InitBoard, 1, 1),
    choose_move(InitBoard, DifficultyBot1, b|1, [OrigLineP1M1/OrigColP1M1, DestLineP1M1/DestColP1M1]),
    move([OrigLineP1M1/OrigColP1M1, DestLineP1M1/DestColP1M1], InitBoard, BoardPostP1First),!,  
    sleep(0.1),

    %%PLAYER 1 SECOND MOVE%%
    display_game(BoardPostP1First, 1, 2),
    choose_move(BoardPostP1First, DifficultyBot1, b|2, [OrigLineP1M1/OrigColP1M1, DestLineP1M1/DestColP1M1], [[OrigLineP1M2/OrigColP1M2, DestLineP1M2/DestColP1M2],PiecePushed1]),
    pushPiece(BoardPostP1First, BoardPostP1Push, PiecePushed1),!,
    move([OrigLineP1M2/OrigColP1M2, DestLineP1M2/DestColP1M2], BoardPostP1Push, BoardPostP1Second),!,
    sleep(0.1),

    %%CHECK GAME OVER
    (gameOver(BoardPostP1Second, Winner), printBoard(BoardPostP1Second, Winner);

    %%PLAYER 2 FIRST MOVE%%
    display_game(BoardPostP1Second, 2, 1),!,
    choose_move(BoardPostP1Second, DifficultyBot2, w|1, [OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1]),
    move([OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1], BoardPostP1Second, BoardPostP2First),!,
    sleep(0.1),

    %%PLAYER 2 SECOND MOVE%%
    display_game(BoardPostP2First, 2, 2),!,
    choose_move(BoardPostP1Second, DifficultyBot2, w|2, [OrigLineP2M1/OrigColP2M1, DestLineP2M1/DestColP2M1], [[OrigLineP2M2/OrigColP2M2, DestLineP2M2/DestColP2M2],PiecePushed2]),
    pushPiece(BoardPostP2First, BoardPostP2Push, PiecePushed2),!,
    move([OrigLineP2M2/OrigColP2M2, DestLineP2M2/DestColP2M2], BoardPostP2Push, BoardPostP2Second),!,
    sleep(0.1),

    %%NEXT TURN
    playMvsM(BoardPostP2Second, DifficultyBot1, DifficultyBot2)).

