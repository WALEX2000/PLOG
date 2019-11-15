:-use_module(library(lists)).
:-use_module(library(ansi_term)).

symbol(w,'○').
symbol(b,'●').
symbol(e,' ').

% Mudar para dar print dependendo do tamanho de cada tabuleiro
printTopDivModules(MaxSize, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╗', []));
        (ansi_format([bg('white'), fg('black')], '═══╗', []))).

printTopDivModules(N_module, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╦', []));
        (ansi_format([bg('white'), fg('black')], '═══╦', []))),
     N is N_module + 1,
     printTopDivModules(N,MaxSize, Color).

printTopDivisor(BoardSize):-
    write('  '),
    ansi_format([bg('black'), fg('white')], '╔', []),
    printTopDivModules(1,BoardSize, 'white'),
    write('     '),
    ansi_format([bg('white'), fg('black')], '╔', []),
    printTopDivModules(1,BoardSize, 'black').

printMidDivisorModules(MaxSize, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╣', []));
        (ansi_format([bg('white'), fg('black')], '═══╣', []))).

printMidDivisorModules(N_module, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╬', []));
        (ansi_format([bg('white'), fg('black')], '═══╬', []))),
    N is N_module + 1,
    printMidDivisorModules(N,MaxSize, Color).

printMidDivisor(BoardSize) :-
    write('  '),
    ansi_format([bg('black'), fg('white')], '╠', []),
    printMidDivisorModules(1,BoardSize, 'white'),
    write('     '),
    ansi_format([bg('white'), fg('black')], '╠', []),
    printMidDivisorModules(1,BoardSize, 'black').

printBotDivisorModules(MaxSize, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╝', []));
        (ansi_format([bg('white'), fg('black')], '═══╝', []))).

printBotDivisorModules(N_module, MaxSize, Color):-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '═══╩', []));
        (ansi_format([bg('white'), fg('black')], '═══╩', []))),
    N is N_module + 1,
    printBotDivisorModules(N,MaxSize, Color).

printBotDivisor(BoardSize) :-
    write('  '),
    ansi_format([bg('black'), fg('white')], '╚', []),
    printBotDivisorModules(1,BoardSize, 'white'),
    write('     '),
    ansi_format([bg('white'), fg('black')], '╚', []),
    printBotDivisorModules(1,BoardSize, 'black').

printDivisor(BoardSize, BoardSize) :-
    printBotDivisor(BoardSize).
printDivisor(_, BoardSize) :-
    printMidDivisor(BoardSize).

printCell(Cell, Color) :-
    symbol(Cell, Char),
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '║ ~w ', [Char]));
        (ansi_format([bg('white'), fg('black')], '║ ~w ', [Char]))).

printRow([], Color) :-
    (Color=='white',
        (ansi_format([bg('black'), fg('white')], '║', []));
        (ansi_format([bg('white'), fg('black')], '║', []))).

printRow([Cell|Rest], Color) :-
    printCell(Cell, Color),
    printRow(Rest, Color).

% L returns the ASCII code for the correct letter
letter(NRow, HalfN, BoardSize, L):-
    L is 65 + NRow + BoardSize*HalfN.

printPairRows(_, _, BoardSize, BoardSize, _).
printPairRows(Board1, Board2, BoardSize, Nrow, HalfN):-
    nth0(Nrow, Board1, Row1), nth0(Nrow, Board2, Row2), %Get rows from both boards
    nl,
    letter(Nrow, HalfN, BoardSize, Letter), char_code(Char, Letter), write(Char), write(' '), %print row letter identifier
    printRow(Row1, 'white'),
    write('     '),
    printRow(Row2, 'black'),
    write(' '), write(Char),
    nl,
    Temp is Nrow + 1, printDivisor(Temp, BoardSize),
    NextRow is Nrow + 1,
    printPairRows(Board1, Board2, BoardSize, NextRow, HalfN).

printBoardPair(BoardPair, BoardSize, HalfN) :-
    printTopDivisor(BoardSize),
    nth0(0, BoardPair, Board1), nth0(1, BoardPair, Board2), %Get Board1 and Board2 from the pair
    printPairRows(Board1, Board2, BoardSize, 0, HalfN). %Print both rows in succession

% Mudar para dar print dependendo do tamanho de cada tabuleiro
printfColID(BoardSize, BoardSize):-
    write(' '),
    ((BoardSize < 10, write(BoardSize), write('  '));
     (BoardSize > 9, write(BoardSize))).

printfColID(Id, BoardSize):-
    write(' '),
    ((Id < 10, write(Id), write('  '));
     (Id > 9, write(Id), write(' '))),
    Id1 is Id + 1,
    printfColID(Id1, BoardSize).

printColumnIDs(BoardSize) :-
    write('   '),
    printfColID(1, BoardSize),
    write('      '), 
    BoardLimit is BoardSize*2,
    ScndHalf is BoardSize+1,
    % print second half now
    printfColID(ScndHalf, BoardLimit),
    write('\n').

% TODO print line accordingly to boardSize
printRope(BoardSize, BoardSize).
printRope(Nstrokes, BoardSize):-
    write('-'),
    N is Nstrokes + 1,
    printRope(N, BoardSize).

printBoardsSeparator(BoardSize) :-
    nl,
    Nstrokes is (BoardSize+1)*2 + (BoardSize*3*2) + 5 + 2,
    write('\no'), printRope(0, Nstrokes), write('o\n'),
    nl.

% Dar Print ao Board independentemente do tamanho de cada board
% BP1 é a topHalf e BP2 a bottomHalf do tabuleiro
% É Preciso ir buscar o tamanho de cada tabuleiro invidual a partir disto
% para isso tenho de ir ao primeiro elem de BP1 (Primeiro board) e dps ir ao primeiro elemento desse (primeira linha) e contar no numero de elementos presentes.
printBoard([BP1|[BP2|_]]) :-
    nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    %Print the board´s column numbers
    printColumnIDs(BoardSize),
    % print top half
    printBoardPair(BP1, BoardSize, 0),
    %Print Rope
    printBoardsSeparator(BoardSize),
    % print bottom half
    printBoardPair(BP2, BoardSize, 1),
    %Print the board´s column numbers again for bottom
    nl, printColumnIDs(BoardSize).

% Need to identify which move we are in as well and highlight accordingly
display_game(Board, Player, Move) :-
    nl,
    write('Player '),
    write(Player),
    write(' playing (Move '),
    write(Move),
    write('):\n'),
    nl,
    printBoard(Board).

% TODO Preciso Por o Board com cores e tamanho variavel
% Sempre que estou a fazer write de qualquer coisa dentro de uma Row tenho de fazer:
% ansi_format([bg('#1f1e1e')], 'TEXT', []), ou ansi_format([bg('white')], 'TEXT', []),
% dependendo da cor to tabuleiro em questão
