:-use_module(library(lists)).

%Checks if game is over
gameOver(Board):-
    nth0(0, Board, SmallBoardPair1),
    nth0(0, SmallBoardPair1, SmallBoard1),
    nth0(1, SmallBoardPair1, SmallBoard2),
    nth0(1, Board, SmallBoardPair2),
    nth0(0, SmallBoardPair2, SmallBoard3),
    nth0(1, SmallBoardPair2, SmallBoard4),
    (\+existsBothPieceTypes(SmallBoard1);
    \+existsBothPieceTypes(SmallBoard2);
    \+existsBothPieceTypes(SmallBoard3);
    \+existsBothPieceTypes(SmallBoard4)).

%Checks if both white and black piece types exist in small board
existsBothPieceTypes(SmallBoard) :-
    hasBlackPiece(SmallBoard),
    hasWhitePiece(SmallBoard).

%Checks if white piece types exist in small board
hasWhitePiece([w|_]).
hasWhitePiece([SmallBoardLine|_]):-
    hasWhitePiece(SmallBoardLine).
hasWhitePiece([_|Rest]):-
    hasWhitePiece(Rest).

%Checks if white piece types exist in small board
hasBlackPiece([b|_]).
hasBlackPiece([SmallBoardLine|_]):-
    hasBlackPiece(SmallBoardLine).
hasBlackPiece([_|Rest]):-
    hasBlackPiece(Rest).

%Moves a pushed piece in move 2
pushPiece(InBoard, InBoard, []).
pushPiece(InBoard, OutBoard, [OrigLine/OrigCol]):-
    setTile(InBoard, OutBoard, OrigLine, OrigCol, 'e', _).
pushPiece(InBoard, OutBoard, [OrigLine/OrigCol,DestLine/DestCol]):-
    move(InBoard, OutBoard, OrigLine, OrigCol, DestLine, DestCol).


%Player: w|1, w|2, b|1, b|2 (White or Black, 1º ou 2º jogada)
%LastMove comes in the following format [Yi/Xi, Yf/Xf]
%ListOfMoves comes in the following format [[Yi/Xi, Yf/Xf],[Yi/Xi, Yf/Xf]]; o movimento pode estar vazio e corresponde a uma peça enimiga empurrada
valid_moves(Board, Player, LastMove, ListOfMoves):-
    nth0(0, Board, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    TotalSize is BoardSize*2,
    findall([[Yi/Xi, Yf/Xf], PiecePushed], getAllMoves(Board, TotalSize, Player, LastMove, Yi/Xi, Yf/Xf, PiecePushed), ListOfMoves).
    %printList(ListOfMoves).

valid_moves(Board, Player, ListOfMoves) :-
    nth0(0, Board, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    TotalSize is BoardSize*2,
    %findall(Yi/Xi, getAllPieces(Board, Player, TotalSize, Yi/Xi), ListOfMoves),
    findall([Yi/Xi, Yf/Xf], getAllMoves(Board, TotalSize, Player, Yi/Xi, Yf/Xf), ListOfMoves).
    %printList(ListOfMoves).

%DEBUG For printing a list
printList([]).
printList([Head|Rest]):-
    write(Head), nl, printList(Rest).

%gets all coordinates inside the board
insideBoard(TotalSize, Y/X):-
    LastPos is TotalSize - 1,
    numlist(0, LastPos, L),
    member(Y, L), member(X, L).   

%TODO Also needs to check if on the play after he´s able to execute this move
%Yf/Xf will be returned in general coordinates
checkMove1Destination(Board, Yi/Xi, Yf/Xf):-
    %Forward
    (Yf is Yi + 1, Xf is Xi, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Xf is Xi, checkEmptyPosition(Board, Temp/Xf, Yi/Xi), Yf is Yi + 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Backwards
    (Yf is Yi - 1, Xf is Xi, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Xf is Xi, checkEmptyPosition(Board, Temp/Xf, Yi/Xi), Yf is Yi - 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Right
    (Xf is Xi + 1, Yf is Yi, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi + 1, Yf is Yi, checkEmptyPosition(Board, Yf/Temp, Yi/Xi), Xf is Xi + 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Left
    (Xf is Xi - 1, Yf is Yi, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi - 1, Yf is Yi, checkEmptyPosition(Board, Yf/Temp, Yi/Xi), Xf is Xi - 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Left
    (Xf is Xi - 1, Yf is Yi, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Xi - 1, Yf is Yi, checkEmptyPosition(Board, Yf/Temp, Yi/Xi), Xf is Xi - 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Diag TopRight
    (Yf is Yi - 1, Xf is Xi + 1, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Temp2 is Xi + 1, checkEmptyPosition(Board, Temp/Temp2, Yi/Xi), Yf is Yi - 2, Xf is Xi + 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Diag Topleft
    (Yf is Yi - 1, Xf is Xi - 1, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi - 1, Temp2 is Xi - 1, checkEmptyPosition(Board, Temp/Temp2, Yi/Xi), Yf is Yi - 2, Xf is Xi - 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Diag Botleft
    (Yf is Yi + 1, Xf is Xi - 1, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Temp2 is Xi - 1, checkEmptyPosition(Board, Temp/Temp2, Yi/Xi), Yf is Yi + 2, Xf is Xi - 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    %Diag BotRight
    (Yf is Yi + 1, Xf is Xi + 1, checkEmptyPosition(Board, Yf/Xf, Yi/Xi));
    (Temp is Yi + 1, Temp2 is Xi + 1, checkEmptyPosition(Board, Temp/Temp2, Yi/Xi), Yf is Yi + 2, Xf is Xi + 2, checkEmptyPosition(Board, Yf/Xf, Yi/Xi)).

%Checks if a certain general position is empty (e)
checkEmptyPosition(Board, Yf/Xf, Yi/Xi):-
    generalToBoardCoords(Yi, Xi, Board, _, _, Bxi, Byi),
    generalToBoardCoords(Yf, Xf, Board, Row, Col, Bx, By), Bx = Bxi, By = Byi,
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    checkIfPieceExists(SmallBoard, e, Row/Col).

checkIfPieceExists(SmallBoard, PieceType, Row/Col):-
    nth0(Row, SmallBoard, List), nth0(Col, List, Piece),
    Piece = PieceType.

%Checks if Yi/Xi position is valid for the first move
getMove1Piece(TotalSize, PieceType, Board, Yi/Xi):-
    HalfSize is TotalSize/2,
    ((PieceType = w, Yi @>= HalfSize);
     (PieceType = b, Yi @< HalfSize)),
    generalToBoardCoords(Yi, Xi, Board, Row, Col, Bx, By),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    checkIfPieceExists(SmallBoard, PieceType, Row/Col). 

%Checks if Yi/Xi position is valid for the second move
getMove2Piece(Board, Yi/Xi, PieceType, LastMove):-
    %Yi/Xi = 4/0, trace,
    %Determine which boards Yi/Xi can be in, depending on LastMove
    LastMove = [LYi/LXi|_],
    %Get LastMove Board X coord and check if Yi/Xi is a valid piece
    generalToBoardCoords(LYi, LXi, Board, _, _, LBx, _),
    ((LBx = 0, Bx = 1, generalToBoardCoords(Yi, Xi, Board, Row, Col, Bx, By));
     (LBx = 1, Bx1 = 0, generalToBoardCoords(Yi, Xi, Board, Row, Col, Bx1, By))),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    checkIfPieceExists(SmallBoard, PieceType, Row/Col).

outOfRange(SmallBoard, Y/X):-
    length(SmallBoard, Length), L is Length - 1,
    (\+between(0, L, X);
    \+between(0, L, Y), between(0, L, X)).
    
moveRange(Ydiff, 0, Range):-
    abs(Ydiff, Range).

moveRange(0, Xdiff, Range):-
    abs(Xdiff, Range).

moveRange(Ydiff, Ydiff, Range):-
    abs(Ydiff, Range).

moveRange(Ydiff, Xdiff, Range):-
    Ydiff is - Xdiff,
    abs(Ydiff, Range).

localToGlobalCoords(Bx, By, BoardSize, Yl/Xl, Yg/Xg):-
    Yg is Yl + BoardSize*By,
    Xg is Xl + BoardSize*Bx.

%Either Yf/Xf is empty and PiecePushed is [Yi/Xi, Yf/Xf] OR
%Yf/Xf is out of board and PiecePushed is [Yi/Xi]
checkIfCanPushPiece(Yi/Xi, Yf/Xf, SmallBoard, Bx, By, PiecePushed):-
    SmallBoard = [Row|_], length(Row, Length),
    localToGlobalCoords(Bx, By, Length, Yi/Xi, Yig/Xig),
    localToGlobalCoords(Bx, By, Length, Yf/Xf, Yfg/Xfg),
    ((outOfRange(SmallBoard, Yf/Xf), PiecePushed = [Yig/Xig]);
    (checkIfPieceExists(SmallBoard, e, Yf/Xf), PiecePushed = [Yig/Xig, Yfg/Xfg])).

checkIfPathIsValid(Yi/Xi, Yf/Xf, SmallBoard, PieceType, Bx, By, PiecePushed):-
    %Yi/Xi = 2/1, trace,
    ((PieceType = w, EnemyPiece = b); (PieceType = b, EnemyPiece = w)),
    Ydiff is Yf - Yi, Xdiff is Xf - Xi,
    %In case movement has only 1 pos in length
    ((moveRange(Ydiff, Xdiff, 1),
     ((checkIfPieceExists(SmallBoard, e, Yf/Xf), PiecePushed = []); %If it's empty it's all good
     (checkIfPieceExists(SmallBoard, EnemyPiece, Yf/Xf),
      NextY is Yf + Ydiff, NextX is Xf + Xdiff,
      checkIfCanPushPiece(Yf/Xf, NextY/NextX, SmallBoard, Bx, By, PiecePushed))));
    %In case movement has 2 pos in length
    (moveRange(Ydiff, Xdiff, 2),
     IntY is Yi + Ydiff/2, IntX is Xi + Xdiff/2,
     LastY is Yf + Ydiff/2, LastX is Xf + Xdiff/2, 
     %In case first position is empty
     ((checkIfPieceExists(SmallBoard, e, IntY/IntX),
      checkIfPieceExists(SmallBoard, PieceFound, Yf/Xf),
      ((PieceFound = e, PiecePushed = []);
       (PieceFound = EnemyPiece,
        checkIfCanPushPiece(Yf/Xf, LastY/LastX, SmallBoard, Bx, By, PiecePushed))));
     %In case first position isn't empty
     (checkIfPieceExists(SmallBoard, EnemyPiece, IntY/IntX),
      checkIfPieceExists(SmallBoard, e, Yf/Xf),
      checkIfCanPushPiece(IntY/IntX, LastY/LastX, SmallBoard, Bx, By, PiecePushed))))).

checkMove2Destination(Board, LastMove, Yi/Xi, Yf/Xf, PieceType, PiecePushed):-
    %Difference between Yi/Xi and Yf/Xf needs to be the same as in LastMove
    LastMove = [LYi/LXi|[LYf/LXf]],
    Yf is Yi + (LYf - LYi), Xf is Xi + (LXf - LXi),
    %Yf/Xf need to be inside the same board boundaries as Yi/Xi
    generalToBoardCoords(Yi, Xi, Board, Rowi, Coli, Bx, By),
    generalToBoardCoords(Yf, Xf, Board, Rowf, Colf, Bx, By),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    checkIfPathIsValid(Rowi/Coli, Rowf/Colf, SmallBoard, PieceType, Bx, By, PiecePushed).
    %If enemy piece is push out of the board then PiecePushed will be [EYi/EXi] else  [EYi/EXi, EYf/EXf]

%Acceptance function for moves a player can execute in the second turn
getAllMoves(Board, TotalSize, PieceType|2, LastMove, Yi/Xi, Yf/Xf, PiecePushed) :-
    insideBoard(TotalSize, Yi/Xi),
    getMove2Piece(Board, Yi/Xi, PieceType, LastMove),
    checkMove2Destination(Board, LastMove, Yi/Xi, Yf/Xf, PieceType, PiecePushed).


%Acceptance function for moves a player can execute in the first turn
getAllMoves(Board, TotalSize, PieceType|1, Yi/Xi, Yf/Xf) :-
    insideBoard(TotalSize, Yi/Xi),
    (getMove1Piece(TotalSize, PieceType, Board, Yi/Xi), checkMove1Destination(Board, Yi/Xi, Yf/Xf)),
    move(Board, TempBoard, Yi, Xi, Yf, Xf), valid_moves(TempBoard, PieceType|2, [Yi/Xi, Yf/Xf], ListOfMoves),
    \+ListOfMoves = [].

%DEBUG ONLY
%Gets all the pieces a certain player can Play on this move
getAllPieces(Board, PieceType|Move, TotalSize, Yi/Xi):-
    insideBoard(TotalSize, Yi/Xi),
    (Move = 1, getMove1Piece(TotalSize, PieceType, Board, Yi/Xi)).

%Moves a piece from OrigLive to OrigCol and returns the board in OutBoard
move(InBoard, OutBoard, OrigLine, OrigCol, DestLine, DestCol) :-
    setTile(InBoard, TempBoard, OrigLine, OrigCol, 'e', PastSymbol),
    setTile(TempBoard, OutBoard, DestLine, DestCol, PastSymbol, _).

%Sets a tile to Symbol and returns the new Board in OutBoard and the symbol that was there previously to PastSymbol
setTile(InBoard, OutBoard, GeneralLine, GeneralCol, Symbol, PastSymbol) :-
    generalToBoardCoords(GeneralLine, GeneralCol, InBoard, BoardLine, BoardCol, X, Y),
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
generalToBoardCoords(InGeneralLine, InGeneralCol, InBoard, OutBoardLine, OutBoardCol, OutBoardX, OutBoardY):-
    nth0(0, InBoard, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    ((InGeneralLine @>= BoardSize,
        (NewLine is InGeneralLine - BoardSize, OutBoardLine = NewLine, OutBoardY = 1));
        (InGeneralLine @< BoardSize, OutBoardLine = InGeneralLine, OutBoardY = 0)),
    ((InGeneralCol @>= BoardSize,
        (NewCol is InGeneralCol - BoardSize, OutBoardCol = NewCol, OutBoardX = 1));
        (InGeneralCol @< BoardSize, OutBoardCol = InGeneralCol, OutBoardX = 0)).
