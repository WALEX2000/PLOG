:-use_module(library(lists)).

%Player: w|1, w|2, b|1, b|2 (White or Black, 1º ou 2º jogada)
valid_moves(Board, Player, ListOfMoves) :-
    nth0(0, Board, BP1), nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    %create a pair X/Y from 0/0 to Size-1/Size-1,
    TotalSize is BoardSize*2,
    getAllMoves(TotalSize, 0,0, Board, Player, ListOfMoves).

%Get X/Y is the current board positon
%The ListOfMoves is filled with [Xf1/Yf1, Xf2/Yf2].
getAllMoves(Size, X,Y, Board, Player, [Head|Rest]):-
    (X > 8, write(Size)); 
    write(X), write("/"), write(Y), write("\n"),
    %Get All moves for this piece
    (valid_move(Board, Player, X/Y, PossibleMoves),
    %add Possible moves to ListOfMoves
    Rest = [PossibleMoves|More],
    %Test next Pair
    X1 is X + 1,
    getAllMoves(Size, X1,Y, Board, Player, More));
    X1 is X + 1,
    getAllMoves(Size, X1,Y, Board, Player, More),

getAllMoves(Size,Size, Size, _, _, _).
getAllMoves(Size, Y, Size, Board, Player, ListOfMoves):-
    Y1 is Y + 1,
    getAllMoves(0,Y1, Size, Board, Player, ListOfMoves).

%Passar lista de Peças (Posições) que se pode mexer
%Cada peça pode mexer 1 ou 2 casa em cada direção desde que esteja dentro do board (> 0 && < boardSize)
%[Se primeira jogada]: De cada posição ver todas as que colidem/passam por outra peça e não aceitar (ou seja se vai mexer 1 para a frente e n aceita ent nem vê o 2 para a frente)
%[Se Segunda jogada]: De cada posição ver as que colide/passa por outra peça da msm equipa (fazer o msm q na primeira jogada nesse caso)
%[Segudna jogada]: Se colidir com alguma peça do adversário verificar se essa pessa pode ser arrastada para trás(Se a pos. atrás está ou fora do board ou livre).
%Note quando uma peça é arrastada para fora do board deve ser eliminada (talvez seja só não voltar a coloca-la dps de a tirar)

%Needs to have full board in order to check if there´ll be any valid moves after this play is made
%Needs to have a board pair consisting only of the current 2 smallBoards that the player can move pieces in
%Next, depending on the current move get a differente board Pair (1st move, just get 1st or 2nd pos| 2nd move needs to build the board depending on the 1st move)

valid_move(Board, PieceType|_, Xi/Yi, Xf/Yf) :-
    %First determine size of board
    %Determinar se Xi/Yi corresponde a uma peça do jogador correto no taubleiro
    generalToBoardCoords(Yi, Xi, Board, Rowi, Coli, BoardX, BoardY),
    nth0(BoardY, Board, BP), nth0(BoardX, BP, SmallBoard),
    %Para já apenas fazer 1º jogada
    checkIfPieceExists(SmallBoard, PieceType, Coli/Rowi),
    Xf = Coli, Yf = Rowi. 

checkIfPieceExists(SmallBoard, PieceType, Col/Row):-
    nth0(Row, SmallBoard, List), nth0(Col, List, Piece),
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
        (NewLine is InGeneralLine - BoardSize, OutBoardLine = NewLine, OutBoardY = 1));
        (OutBoardLine = InGeneralLine, OutBoardY = 0)),
    ((InGeneralCol @>= BoardSize,
        (NewCol is InGeneralCol - BoardSize, OutBoardCol = NewCol, OutBoardX = 1));
        (OutBoardCol = InGeneralCol, OutBoardX = 0)).
