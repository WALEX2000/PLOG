:-use_module(library(lists)).

%Checks if game is over
game_over(Board, Winner):-
    nth0(0, Board, SmallBoardPair1),
    nth0(0, SmallBoardPair1, SmallBoard1),
    nth0(1, SmallBoardPair1, SmallBoard2),
    nth0(1, Board, SmallBoardPair2),
    nth0(0, SmallBoardPair2, SmallBoard3),
    nth0(1, SmallBoardPair2, SmallBoard4),
    (
        \+exists_both_piece_types(SmallBoard1);
        \+exists_both_piece_types(SmallBoard2);
        \+exists_both_piece_types(SmallBoard3);
        \+exists_both_piece_types(SmallBoard4)
    ),
    (
        (\+has_black_piece(SmallBoard1),has_white_piece(SmallBoard1),Winner=1);
        (has_black_piece(SmallBoard1),\+has_white_piece(SmallBoard1),Winner=2);
        (\+has_black_piece(SmallBoard2),has_white_piece(SmallBoard2),Winner=1);
        (has_black_piece(SmallBoard2),\+has_white_piece(SmallBoard2),Winner=2);
        (\+has_black_piece(SmallBoard3),has_white_piece(SmallBoard3),Winner=1);
        (has_black_piece(SmallBoard3),\+has_white_piece(SmallBoard3),Winner=2);
        (\+has_black_piece(SmallBoard4),has_white_piece(SmallBoard4),Winner=1);
        (has_black_piece(SmallBoard4),\+has_white_piece(SmallBoard4),Winner=2)
    ).

%Checks if both white and black piece types exist in small board
exists_both_piece_types(SmallBoard) :-
    has_black_piece(SmallBoard),
    has_white_piece(SmallBoard).

%Checks if white piece types exist in small board
has_white_piece([w|_]).
has_white_piece([SmallBoardLine|_]):-
    has_white_piece(SmallBoardLine).
has_white_piece([_|Rest]):-
    has_white_piece(Rest).

%Checks if white piece types exist in small board
has_black_piece([b|_]).
has_black_piece([SmallBoardLine|_]):-
    has_black_piece(SmallBoardLine).
has_black_piece([_|Rest]):-
    has_black_piece(Rest).

%Moves a pushed piece in move 2
push_piece(InBoard, InBoard, []).
push_piece(InBoard, OutBoard, [OrigLine/OrigCol]):-
    set_tile(InBoard, OutBoard, OrigLine, OrigCol, 'e', _).
push_piece(InBoard, OutBoard, [OrigLine/OrigCol,DestLine/DestCol]):-
    move([OrigLine/OrigCol, DestLine/DestCol], InBoard, OutBoard).


%Player: w|1, w|2, b|1, b|2 (White or Black, 1º ou 2º jogada)
%LastMove comes in the following format [Yi/Xi, Yf/Xf]
%ListOfMoves comes in the following format [[Yi/Xi, Yf/Xf],[Yi/Xi, Yf/Xf]]; o movimento pode estar vazio e corresponde a uma peça enimiga empurrada
valid_moves(Board, Player, LastMove, ListOfMoves):-
    board_size(Board, BoardSize),
    TotalSize is BoardSize*2,
    findall([[Yi/Xi, Yf/Xf], PiecePushed], get_all_moves(Board, TotalSize, Player, LastMove, Yi/Xi, Yf/Xf, PiecePushed), ListOfMoves).
    %print_list(ListOfMoves).

valid_moves(Board, Player, ListOfMoves) :-
    board_size(Board, BoardSize),
    TotalSize is BoardSize*2,
    findall([Yi/Xi, Yf/Xf], get_all_moves(Board, TotalSize, Player, Yi/Xi, Yf/Xf), ListOfMoves).
    %print_list(ListOfMoves).

%DEBUG For printing a list
print_list([]).
print_list([Head|Rest]):-
    write(Head), nl, print_list(Rest).

%gets all coordinates inside the board
inside_board(TotalSize, Y/X):-
    LastPos is TotalSize - 1,
    numlist(0, LastPos, L),
    member(Y, L), member(X, L).   

%TODO Also needs to check if on the play after he´s able to execute this move
%Yf/Xf will be returned in general coordinates
check_move1_destination(Board, Yi/Xi, Yf/Xf):-
    %Forward
    (Yf is Yi + 1, Xf is Xi, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Xf is Xi, check_empty_position(Board, Temp/Xf, Yi/Xi), Yf is Yi + 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Backwards
    (Yf is Yi - 1, Xf is Xi, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Xf is Xi, check_empty_position(Board, Temp/Xf, Yi/Xi), Yf is Yi - 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Right
    (Xf is Xi + 1, Yf is Yi, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi + 1, Yf is Yi, check_empty_position(Board, Yf/Temp, Yi/Xi), Xf is Xi + 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Left
    (Xf is Xi - 1, Yf is Yi, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi - 1, Yf is Yi, check_empty_position(Board, Yf/Temp, Yi/Xi), Xf is Xi - 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Left
    (Xf is Xi - 1, Yf is Yi, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi - 1, Yf is Yi, check_empty_position(Board, Yf/Temp, Yi/Xi), Xf is Xi - 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Diag TopRight
    (Yf is Yi - 1, Xf is Xi + 1, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Temp2 is Xi + 1, check_empty_position(Board, Temp/Temp2, Yi/Xi), Yf is Yi - 2, Xf is Xi + 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Diag Topleft
    (Yf is Yi - 1, Xf is Xi - 1, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Temp2 is Xi - 1, check_empty_position(Board, Temp/Temp2, Yi/Xi), Yf is Yi - 2, Xf is Xi - 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Diag Botleft
    (Yf is Yi + 1, Xf is Xi - 1, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Temp2 is Xi - 1, check_empty_position(Board, Temp/Temp2, Yi/Xi), Yf is Yi + 2, Xf is Xi - 2, check_empty_position(Board, Yf/Xf, Yi/Xi));
    %Diag BotRight
    (Yf is Yi + 1, Xf is Xi + 1, check_empty_position(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Temp2 is Xi + 1, check_empty_position(Board, Temp/Temp2, Yi/Xi), Yf is Yi + 2, Xf is Xi + 2, check_empty_position(Board, Yf/Xf, Yi/Xi)).

%Checks if a certain general position is empty (e)
check_empty_position(Board, Yf/Xf, Yi/Xi):-
    general_to_board_coords(Yi, Xi, Board, _, _, Bxi, Byi),
    general_to_board_coords(Yf, Xf, Board, Row, Col, Bx, By), Bx = Bxi, By = Byi,
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    check_if_piece_exists(SmallBoard, e, Row/Col).

check_if_piece_exists(SmallBoard, PieceType, Row/Col):-
    nth0(Row, SmallBoard, List), nth0(Col, List, Piece),
    Piece = PieceType.

%Checks if Yi/Xi position is valid for the first move
get_move1_piece(TotalSize, PieceType, Board, Yi/Xi):-
    HalfSize is TotalSize/2,
    ((PieceType = w, Yi @>= HalfSize);
     (PieceType = b, Yi @< HalfSize)),
    general_to_board_coords(Yi, Xi, Board, Row, Col, Bx, By),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    check_if_piece_exists(SmallBoard, PieceType, Row/Col). 

%Checks if Yi/Xi position is valid for the second move
get_move2_piece(Board, Yi/Xi, PieceType, LastMove):-
    %Determine which boards Yi/Xi can be in, depending on LastMove
    LastMove = [LYi/LXi|_],
    %Get LastMove Board X coord and check if Yi/Xi is a valid piece
    general_to_board_coords(LYi, LXi, Board, _, _, LBx, _),
    ((LBx = 0, Bx = 1, general_to_board_coords(Yi, Xi, Board, Row, Col, Bx, By));
    (LBx = 1, Bx = 0, general_to_board_coords(Yi, Xi, Board, Row, Col, Bx, By))),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    check_if_piece_exists(SmallBoard, PieceType, Row/Col).

out_of_range(SmallBoard, Y/X):-
    length(SmallBoard, Length), L is Length - 1,
    (\+between(0, L, X);
    \+between(0, L, Y), between(0, L, X)).
    
move_range(Ydiff, 0, Range):-
    abs(Ydiff, Range).

move_range(0, Xdiff, Range):-
    abs(Xdiff, Range).

move_range(Ydiff, Ydiff, Range):-
    abs(Ydiff, Range).

move_range(Ydiff, Xdiff, Range):-
    Ydiff is - Xdiff,
    abs(Ydiff, Range).

%Either Yf/Xf is empty and PiecePushed is [Yi/Xi, Yf/Xf] OR
%Yf/Xf is out of board and PiecePushed is [Yi/Xi]
check_if_can_push_piece(Yi/Xi, Yf/Xf, SmallBoard, Bx, By, PiecePushed):-
    SmallBoard = [Row|_], length(Row, Length),
    board_to_general_coords(Bx, By, Length, Yi/Xi, Yig/Xig),
    board_to_general_coords(Bx, By, Length, Yf/Xf, Yfg/Xfg),
    ((out_of_range(SmallBoard, Yf/Xf), PiecePushed = [Yig/Xig]);
    (check_if_piece_exists(SmallBoard, e, Yf/Xf), PiecePushed = [Yig/Xig, Yfg/Xfg])).

check_if_path_is_valid(Yi/Xi, Yf/Xf, SmallBoard, PieceType, Bx, By, PiecePushed):-
    %Yi/Xi = 2/1, trace,
    ((PieceType = w, EnemyPiece = b); (PieceType = b, EnemyPiece = w)),
    Ydiff is Yf - Yi, Xdiff is Xf - Xi,
    %In case movement has only 1 pos in length
    ((move_range(Ydiff, Xdiff, 1),
     ((check_if_piece_exists(SmallBoard, e, Yf/Xf), PiecePushed = []); %If it's empty it's all good
     (check_if_piece_exists(SmallBoard, EnemyPiece, Yf/Xf),
      NextY is Yf + Ydiff, NextX is Xf + Xdiff,
      check_if_can_push_piece(Yf/Xf, NextY/NextX, SmallBoard, Bx, By, PiecePushed))));
    %In case movement has 2 pos in length
    (move_range(Ydiff, Xdiff, 2),
     IntY is Yi + Ydiff/2, IntX is Xi + Xdiff/2,
     LastY is Yf + Ydiff/2, LastX is Xf + Xdiff/2, 
     %In case first position is empty
     ((check_if_piece_exists(SmallBoard, e, IntY/IntX),
      check_if_piece_exists(SmallBoard, PieceFound, Yf/Xf),
      ((PieceFound = e, PiecePushed = []);
       (PieceFound = EnemyPiece,
        check_if_can_push_piece(Yf/Xf, LastY/LastX, SmallBoard, Bx, By, PiecePushed))));
     %In case first position isn't empty
     (check_if_piece_exists(SmallBoard, EnemyPiece, IntY/IntX),
      check_if_piece_exists(SmallBoard, e, Yf/Xf),
      check_if_can_push_piece(IntY/IntX, LastY/LastX, SmallBoard, Bx, By, PiecePushed))))).

check_move2_destination(Board, LastMove, Yi/Xi, Yf/Xf, PieceType, PiecePushed):-
    %Difference between Yi/Xi and Yf/Xf needs to be the same as in LastMove
    LastMove = [LYi/LXi|[LYf/LXf]],
    Yf is Yi + (LYf - LYi), Xf is Xi + (LXf - LXi),
    %Yf/Xf need to be inside the same board boundaries as Yi/Xi
    general_to_board_coords(Yi, Xi, Board, Rowi, Coli, Bx, By),
    general_to_board_coords(Yf, Xf, Board, Rowf, Colf, Bx, By),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    check_if_path_is_valid(Rowi/Coli, Rowf/Colf, SmallBoard, PieceType, Bx, By, PiecePushed).
    %If enemy piece is push out of the board then PiecePushed will be [EYi/EXi] else  [EYi/EXi, EYf/EXf]

%Acceptance function for moves a player can execute in the second turn
get_all_moves(Board, TotalSize, PieceType|2, LastMove, Yi/Xi, Yf/Xf, PiecePushed) :-
    inside_board(TotalSize, Yi/Xi),
    get_move2_piece(Board, Yi/Xi, PieceType, LastMove),
    check_move2_destination(Board, LastMove, Yi/Xi, Yf/Xf, PieceType, PiecePushed).


%Acceptance function for moves a player can execute in the first turn
get_all_moves(Board, TotalSize, PieceType|1, Yi/Xi, Yf/Xf) :-
    inside_board(TotalSize, Yi/Xi),
    (get_move1_piece(TotalSize, PieceType, Board, Yi/Xi), check_move1_destination(Board, Yi/Xi, Yf/Xf)),
    move([Yi/Xi, Yf/Xf],Board, TempBoard), valid_moves(TempBoard, PieceType|2, [Yi/Xi, Yf/Xf], ListOfMoves),
    \+ListOfMoves = [].

%DEBUG ONLY
%Gets all the pieces a certain player can Play on this move
get_all_pieces(Board, PieceType|Move, TotalSize, Yi/Xi):-
    inside_board(TotalSize, Yi/Xi),
    (Move = 1, get_move1_piece(TotalSize, PieceType, Board, Yi/Xi)).

%Passar lista de Peças (Posições) que se pode mexer
%Cada peça pode mexer 1 ou 2 casa em cada direção desde que esteja dentro do board (> 0 && < boardSize)
%[Se primeira jogada]: De cada posição ver todas as que colidem/passam por outra peça e não aceitar (ou seja se vai mexer 1 para a frente e n aceita ent nem vê o 2 para a frente)
%[Se Segunda jogada]: De cada posição ver as que colide/passa por outra peça da msm equipa (fazer o msm q na primeira jogada nesse caso)
%[Segudna jogada]: Se colidir com alguma peça do adversário verificar se essa pessa pode ser arrastada para trás(Se a pos. atrás está ou fora do board ou livre).
%Note quando uma peça é arrastada para fora do board deve ser eliminada (talvez seja só não voltar a coloca-la dps de a tirar)

%Needs to have full board in order to check if there'll be any valid moves after this play is made
%Needs to have a board pair consisting only of the current 2 smallBoards that the player can move pieces in
%Next, depending on the current move get a differente board Pair (1st move, just get 1st or 2nd pos| 2nd move needs to build the board depending on the 1st move)

move([OrigLine/OrigCol, DestLine/DestCol], InBoard, OutBoard) :-
    set_tile(InBoard, TempBoard, OrigLine, OrigCol, 'e', PastSymbol),
    set_tile(TempBoard, OutBoard, DestLine, DestCol, PastSymbol, _).

set_tile(InBoard, OutBoard, GeneralLine, GeneralCol, Symbol, PastSymbol) :-
    general_to_board_coords(GeneralLine, GeneralCol, InBoard, BoardLine, BoardCol, X, Y),
    nth0(Y, InBoard, BoardPair, BoardRest), 
    nth0(X, BoardPair, SmallBoard, BoardPairRest),
    nth0(BoardLine, SmallBoard, SmallBoardLine, SmallBoardRest),
    nth0(BoardCol, SmallBoardLine, PastSymbol, SmallBoardLineRest),
    nth0(BoardCol, OutSmallBoardLine, Symbol, SmallBoardLineRest),
    nth0(BoardLine, OutSmallBoard, OutSmallBoardLine, SmallBoardRest),
    nth0(X, OutBoardPair, OutSmallBoard, BoardPairRest),
    nth0(Y, OutBoard, OutBoardPair, BoardRest).

%Converts general coordinates (InGeneralLine InGeneralCol) 
%to board-specific coordinates (OutBoardLine OutBoardCol), 
%along with which board is being referenced (OutBoardX OutBoardY)
general_to_board_coords(InGeneralLine, InGeneralCol, InBoard, OutBoardLine, OutBoardCol, OutBoardX, OutBoardY):-
    nth0(0, InBoard, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    ((InGeneralLine @>= BoardSize,
        (NewLine is InGeneralLine - BoardSize, OutBoardLine = NewLine, OutBoardY = 1));
        (InGeneralLine @< BoardSize, OutBoardLine = InGeneralLine, OutBoardY = 0)),
    ((InGeneralCol @>= BoardSize,
        (NewCol is InGeneralCol - BoardSize, OutBoardCol = NewCol, OutBoardX = 1));
        (InGeneralCol @< BoardSize, OutBoardCol = InGeneralCol, OutBoardX = 0)).

board_to_general_coords(Bx, By, BoardSize, Yl/Xl, Yg/Xg):-
    Yg is Yl + BoardSize*By,
    Xg is Xl + BoardSize*Bx.

%​choose_move(+Board, +Level, +Player, -Move)​
%Level comes in 0 or 1
choose_move(Board, 0, PieceType|1, Move):-
    valid_moves(Board, PieceType|1, ListOfMoves),
    length(ListOfMoves, Size),
    Last is Size-1,
    X is random(Last),
    nth0(X, ListOfMoves, Move).
%Choose the move for a level 1 bot difficulty setting
choose_move(Board, 1, PieceType|1, Move):-
    valid_moves(Board, PieceType|1, ListOfMoves),
    %For each move in piece of moves give it a value and store it in a list
    storeValueList(Board, ListOfMoves, PieceType|1, List),
    %Now choose a random move from the list of moves with the highest value
    max_list(List, Max),
    getRandomMaxMove(ListOfMoves, List, Max, Move).
    %printValueList(ListOfMoves, List).

choose_move(Board, 0, PieceType|2, LastMove, Move):-
    valid_moves(Board, PieceType|2, LastMove, ListOfMoves),
    length(ListOfMoves, Size),
    X is random(Size),
    nth0(X, ListOfMoves, Move).
choose_move(Board, 1, PieceType|2, LastMove, Move):-
    valid_moves(Board, PieceType|2, LastMove, ListOfMoves),
    storeValueList(Board, ListOfMoves, PieceType|2, List),
    max_list(List, Max),
    getRandomMaxMove(ListOfMoves, List, Max, Move).

%Print Value List for DEBUG
printValueList([], []).
printValueList([Move|Rest], [Value|OtherValues]):-
    write(Move), write(': '), write(Value), nl,
    printValueList(Rest, OtherValues).

%Gets a random move with max value from the list of moves
getRandomMaxMove(ListOfMoves, List, Max, Move):-
    findall(Index, nth0(Index, List, Max), ListOfIndexes),
    length(ListOfIndexes, Size), X is random(Size),
    nth0(X, ListOfIndexes, ChosenIndex),
    nth0(ChosenIndex, ListOfMoves, Move).

%Returns a List of Values in List
storeValueList(Board, ListOfMoves, PieceType|MoveN, List):-
    storeValueList(Board, ListOfMoves, PieceType|MoveN, [], List).

storeValueList(Board, [Move|Rest], PieceType|MoveN, List, FinalList):-
    value(Board, PieceType|MoveN, Move, Value),
    append(List,[Value],NewList),
    storeValueList(Board, Rest, PieceType|MoveN, NewList, FinalList).

storeValueList(_, [], _, List, FinalList):- FinalList = List.

 
%value(+Board, +Player, -Value)
%Evaluate a board for a plyer's first move
%So on the first move I must give positive value +2 for each piece I can eat in the next move,
%negative value -1 for each piece the enemy could eat on the next move if the board was like this
value(Board, PieceType|1, Move, Value):-
    valid_moves(Board, PieceType|2, Move, ListOfMoves),
    countEatMoves(ListOfMoves, Count),
    move(Move, Board, TempBoard),
    ((PieceType = w, EnemyPiece = b);
     (PieceType = b, EnemyPiece = w)),
    getEnemyMoveValue(TempBoard, 1, EnemyPiece|1, EnemyValue),
    %get the best move's value from the enemy if he played his first move on a board with our Move
    Value is Count * 2 - EnemyValue.

value([BP1|[BP2]], PieceType|2, _, Value):-
    %Go board by board and count how many friendly pieces vs how many enemy's pieces
    nth0(0, BP1, B1), nth0(1, BP1, B2), nth0(0, BP2, B3), nth0(1, BP2, B4),
    valueSmallBoard(B1, PieceType, V1),
    valueSmallBoard(B2, PieceType, V2),
    valueSmallBoard(B3, PieceType, V3),
    valueSmallBoard(B4, PieceType, V4),
    Value is V1 + V2 + V3 + V4.

getEnemyMoveValue(TempBoard, 1, EnemyPiece|1, Value):-
    valid_moves(TempBoard, EnemyPiece|1, ListOfMoves), %Get all valid moves enemy can play on first move
    storeEnemyValueList(TempBoard, ListOfMoves, EnemyPiece|1, List),
    max_list(List, Value).

%Stores a list of values that the enemy has for his next play if it were to happen now
storeEnemyValueList(Board, ListOfMoves, PieceType|1, List):-
    storeEnemyValueList(Board, ListOfMoves, PieceType|1, [], List).

storeEnemyValueList(Board, [Move|Rest], PieceType|1, List, FinalList):-
    valid_moves(Board, PieceType|2, Move, ListOfMoves), %Get all valid moves enemy can play on his second move for a given first move
    countEatMoves(ListOfMoves, Value),
    append(List,[Value],NewList),
    storeEnemyValueList(Board, Rest, PieceType|1, NewList, FinalList).

storeEnemyValueList(_, [], _, List, FinalList):- FinalList = List.

%[[Yi/Xi, Yf/Xf],[Yi/Xf, Yf/Xf]]
%Adds 1 to the moves where [_|[[_|[]]]]
%Moves have a second element that has something in the beggining but nothing after
countEatMoves(ListOfMoves, Count):-
    countEatMoves(ListOfMoves, 0, Count).

countEatMoves([Move|OtherMoves], Count, FinalCount):-
    (Move = [_|[[_|[]]]], NewCount is Count + 1, countEatMoves(OtherMoves, NewCount, FinalCount));
    countEatMoves(OtherMoves, Count, FinalCount).

countEatMoves([], Count, FinalCount):- FinalCount is Count.

countPieces(Row, PieceType, Count):-
    countPieces(Row, PieceType, 0, Count).

countPieces([Elem|Rest], PieceType, Count, FinalCount):-
    (Elem = PieceType, NewCount is Count + 1, countPieces(Rest, PieceType, NewCount, FinalCount));
    countPieces(Rest, PieceType, Count, FinalCount).

countPieces(_, _, Count, FinalCount):- FinalCount is Count.

valueSmallBoard(SmallBoard, w, Value):-
    SmallBoard = [Row1|[Row2|[Row3|[Row4]]]],
    length(Row1, Max),
    countPieces(Row1, w, F1), countPieces(Row2, w, F2),
    countPieces(Row3, w, F3), countPieces(Row4, w, F4),
    countPieces(Row1, b, E1), countPieces(Row2, b, E2),
    countPieces(Row3, b, E3), countPieces(Row4, b, E4),
    Value is Max - E1 - E2 - E3 - E4 + F1 + F2 + F3 + F4.

valueSmallBoard(SmallBoard, b, Value):-
    SmallBoard = [Row1|[Row2|[Row3|[Row4]]]],
    length(Row1, Max),
    countPieces(Row1, b, F1), countPieces(Row2, b, F2),
    countPieces(Row3, b, F3), countPieces(Row4, b, F4),
    countPieces(Row1, w, E1), countPieces(Row2, w, E2),
    countPieces(Row3, w, E3), countPieces(Row4, w, E4),
    Value is Max - E1 - E2 - E3 - E4 + F1 + F2 + F3 + F4.
    