:-use_module(library(lists)).
:-consult('boards.pl').
:-consult('display.pl').
:-consult('logic.pl').
:-consult('input.pl').

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

testValidPos(Moves):-
    %createBoard(4, Board),
    intermediateBoard(Board), 
    display_game(Board, 1),
    valid_moves(Board, b|1, Moves).
