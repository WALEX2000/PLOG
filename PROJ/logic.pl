:-use_module(library(lists)).

valid_moves(Board, Player, ListOfMoves) :-
    setof([OrigLine, OrigCol, DestLine, DestCol], valid_move(Board, Player, OrigLine, OrigCol, DestLine, DestCol), ListOfMoves).

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
