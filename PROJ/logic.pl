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
    %hasBlackPiece(SmallBoard),
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


%Player: w|1, w|2, b|1, b|2 (White or Black, 1º ou 2º jogada)
valid_moves(Board, Player, ListOfMoves) :-
    nth0(0, Board, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    TotalSize is BoardSize*2,
    %findall(Yi/Xi, getAllPieces(Board, Player, TotalSize, Yi/Xi), ListOfMoves),
    findall([Yi/Xi, Yf/Xf], getAllMoves(Board, TotalSize, Player, Yi/Xi, Yf/Xf), ListOfMoves),
    printList(ListOfMoves).

%DEBUG For printing a list
printList([]).
printList([Head|Rest]):-
    write(Head), nl, printList(Rest).

%gets all coordinates inside the board
insideBoard(TotalSize, Y/X):-
    LastPos is TotalSize - 1,
    numlist(0, LastPos, L),
    member(Y, L), member(X, L).

%TODO add -SmallBoard -Row/Col
getMove1Piece(TotalSize, PieceType, Board, Yi/Xi):-
    HalfSize is TotalSize/2,
    ((PieceType = w, Yi @>= HalfSize);
     (PieceType = b, Yi @< HalfSize)),
    generalToBoardCoords(Yi, Xi, Board, Row, Col, Bx, By),
    nth0(By, Board, BP), nth0(Bx, BP, SmallBoard),
    checkIfPieceExists(SmallBoard, PieceType, Row/Col).    

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

%Gets all the pieces a certain player can Play on this move
getAllPieces(Board, PieceType|Move, TotalSize, Yi/Xi):-
    insideBoard(TotalSize, Yi/Xi),
    (Move = 1, getMove1Piece(TotalSize, PieceType, Board, Yi/Xi)).

%Gets all moves a certain player can play on this Move
getAllMoves(Board, TotalSize, PieceType|Move, Yi/Xi, Yf/Xf) :-
    insideBoard(TotalSize, Yi/Xi),
    (Move = 1, getMove1Piece(TotalSize, PieceType, Board, Yi/Xi), checkMove1Destination(Board, Yi/Xi, Yf/Xf)).

%Passar lista de Peças (Posições) que se pode mexer
%Cada peça pode mexer 1 ou 2 casa em cada direção desde que esteja dentro do board (> 0 && < boardSize)
%[Se primeira jogada]: De cada posição ver todas as que colidem/passam por outra peça e não aceitar (ou seja se vai mexer 1 para a frente e n aceita ent nem vê o 2 para a frente)
%[Se Segunda jogada]: De cada posição ver as que colide/passa por outra peça da msm equipa (fazer o msm q na primeira jogada nesse caso)
%[Segudna jogada]: Se colidir com alguma peça do adversário verificar se essa pessa pode ser arrastada para trás(Se a pos. atrás está ou fora do board ou livre).
%Note quando uma peça é arrastada para fora do board deve ser eliminada (talvez seja só não voltar a coloca-la dps de a tirar)

%Needs to have full board in order to check if there'll be any valid moves after this play is made
%Needs to have a board pair consisting only of the current 2 smallBoards that the player can move pieces in
%Next, depending on the current move get a differente board Pair (1st move, just get 1st or 2nd pos| 2nd move needs to build the board depending on the 1st move)

valid_move(Board, PieceType|_, Xi/Yi, Xf/Yf) :-
    %First determine size of board
    %Determinar se Xi/Yi corresponde a uma peça do jogador correto no taubleiro
    generalToBoardCoords(Yi, Xi, Board, Rowi, Coli, BoardX, BoardY),
    nth0(BoardY, Board, BP), nth0(BoardX, BP, SmallBoard),
    %Para já apenas fazer 1º jogada
    checkIfPieceExists(SmallBoard, PieceType, Rowi/Coli),
    Xf = Coli, Yf = Rowi. 

checkIfPieceExists(SmallBoard, PieceType, Row/Col):-
    nth0(Row, SmallBoard, List), nth0(Col, List, Piece),
    %write('Found Piece: '), write(Piece), write(' at: '), write(Row/Col), write('in: '), write(SmallBoard), nl,
    Piece = PieceType.

move(InBoard, OutBoard, OrigLine, OrigCol, DestLine, DestCol) :-
    setTile(InBoard, TempBoard, OrigLine, OrigCol, 'e', PastSymbol),
    setTile(TempBoard, OutBoard, DestLine, DestCol, PastSymbol, _).

setTile(InBoard, OutBoard, GeneralLine, GeneralCol, Symbol, PastSymbol) :-
    generalToBoardCoords(GeneralLine, GeneralCol, InBoard, BoardLine, BoardCol, X, Y),
    nth0(X, InBoard, BoardPair, BoardRest), 
    nth0(Y, BoardPair, SmallBoard, BoardPairRest),
    nth0(BoardLine, SmallBoard, SmallBoardLine, SmallBoardRest),
    nth0(BoardCol, SmallBoardLine, PastSymbol, SmallBoardLineRest),
    nth0(BoardCol, OutSmallBoardLine, Symbol, SmallBoardLineRest),
    nth0(BoardLine, OutSmallBoard, OutSmallBoardLine, SmallBoardRest),
    nth0(Y, OutBoardPair, OutSmallBoard, BoardPairRest),
    nth0(X, OutBoard, OutBoardPair, BoardRest).

%Converts general coordinates (InGeneralLine InGeneralCol) 
%to board-specific coordinates (OutBoardLine OutBoardCol), 
%along with which board is being referenced (OutBoardX OutBoardY)
generalToBoardCoords(InGeneralLine, InGeneralCol, InBoard, OutBoardLine, OutBoardCol, OutBoardX, OutBoardY):-
    nth0(0, InBoard, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    ((InGeneralLine @>= BoardSize,
        (NewLine is InGeneralLine - BoardSize, OutBoardLine = NewLine, OutBoardX = 1));
        (InGeneralLine @< BoardSize, OutBoardLine = InGeneralLine, OutBoardX = 0)),
    ((InGeneralCol @>= BoardSize,
        (NewCol is InGeneralCol - BoardSize, OutBoardCol = NewCol, OutBoardY = 1));
        (InGeneralCol @< BoardSize, OutBoardCol = InGeneralCol, OutBoardY = 0)).
