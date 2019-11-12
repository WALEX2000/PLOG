:-use_module(library(lists)).

%Player: W|1, W|2, B|1, B|2 (White or Black, 1º ou 2º jogada)
valid_moves(Board, Player, ListOfMoves) :-
    setof([OrigLine/OrigCol, DestLine/DestCol], valid_move(Board, Player, OrigLine/OrigCol, DestLine/DestCol), ListOfMoves).

%Passar lista de Peças (Posições) que se pode mexer
%Cada peça pode mexer 1 ou 2 casa em cada direção desde que esteja dentro do board (> 0 && < boardSize)
%[Se primeira jogada]: De cada posição ver todas as que colidem/passam por outra peça e não aceitar (ou seja se vai mexer 1 para a frente e n aceita ent nem vê o 2 para a frente)
%[Se Segunda jogada]: De cada posição ver as que colide/passa por outra peça da msm equipa (fazer o msm q na primeira jogada nesse caso)
%[Segudna jogada]: Se colidir com alguma peça do adversário verificar se essa pessa pode ser arrastada para trás(Se a pos. atrás está ou fora do board ou livre).
%Note quando uma peça é arrastada para fora do board deve ser eliminada (talvez seja só não voltar a coloca-la dps de a tirar)

%Needs to have full board in order to check if there'll be any valid moves after this play is made
%Needs to have a board pair consisting only of the current 2 smallBoards that the player can move pieces in
%Next, depending on the current move get a differente board Pair (1st move, just get 1st or 2nd pos| 2nd move needs to build the board depending on the 1st move)
valid_move([BP1|[BP2|_]], Player, Xi/Yi, Xf/Yf) :-
    %First determine size of board and get individual boards
    nth0(0, BP1, B1), nth0(0, B1, R1), length(R1, BoardSize),
    nth0(1, BP1, B2), nth0(0, BP2, B3), nth0(1, BP2, B4),
    %Determinar se Xi/Yi corresponde a uma peça do jogador correto no taubleiro


%Moves in horizontal line (same line)
%valid_move(Board, Player, OrigLine, OrigCol, OrigLine, DestCol) :-

%Moves in vertical line (same column)
%valid_move(Board, Player, OrigLine, OrigCol, DestLine, OrigCol) :-


move(InBoard, OutBoard, OrigLine, OrigCol, DestLine, DestCol) :-
    setTile(InBoard, TempBoard, OrigLine, OrigCol, 'e', PastSymbol),
    setTile(TempBoard, OutBoard, DestLine, DestCol, PastSymbol, _).

setTile(InBoard, OutBoard, GeneralLine, GeneralCol, Symbol, PastSymbol) :-
    generalToBoardCoords(GeneralLine, GeneralCol, BoardLine, BoardCol, X, Y),
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
generalToBoardCoords(InGeneralLine, InGeneralCol, OutBoardLine, OutBoardCol, OutBoardX, OutBoardY):-
    (InGeneralLine @>= 4,
        (NewLine is InGeneralLine - 4, OutBoardLine = NewLine, OutBoardY = 1);
        (OutBoardLine = InGeneralLine, OutBoardY = 0)),
    (InGeneralCol @>= 4,
        (NewCol is InGeneralCol - 4, OutBoardCol = NewCol, OutBoardX = 1);
        (OutBoardCol = InGeneralCol, OutBoardX = 0)).
