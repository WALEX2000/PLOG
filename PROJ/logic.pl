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

setTile(InBoard, OutBoard, Line, Col, Symbol, PastSymbol) :-
    Col@>=4, 
        (Line@>=4, 
            (BoardLine is Line-4, BoardCol is Col-4,
                switchTile(InBoard, OutBoard, BoardLine, BoardCol, Symbol, PastSymbol)
            );
            (BoardLine is Line, BoardCol is Col-4,
                switchTile(InBoard, OutBoard, BoardLine, BoardCol, Symbol, PastSymbol)
            )
        );
        (Line@>=4, 
            (BoardLine is Line-4, BoardCol is Col,
                switchTile(InBoard, OutBoard, BoardLine, BoardCol, Symbol, PastSymbol)
            );
            (BoardLine is Line, BoardCol is Col,
                switchTile(InBoard, OutBoard, BoardLine, BoardCol, Symbol, PastSymbol)
            )
        ).

switchTile(InBoard, OutBoard, GeneralLine, GeneralCol, Symbol, PastSymbol) :-
    generalToBoardCoords(GeneralLine, GeneralCol, BoardLine, BoardCol, X, Y),
    nth0(X, InBoard, BoardPair, BoardRest), 
    nth0(Y, BoardPair, SmallBoard, BoardPairRest),
    nth0(BoardLine, SmallBoard, SmallBoardLine, SmallBoardRest),
    nth0(BoardCol, SmallBoardLine, PastSymbol, SmallBoardLineRest),
    nth0(BoardCol, OutSmallBoardLine, Symbol, SmallBoardLineRest),
    nth0(BoardLine, OutSmallBoard, OutSmallBoardLine, SmallBoardRest),
    nth0(Y, OutBoardPair, OutSmallBoard, BoardPairRest),
    nth0(X, OutBoard, OutBoardPair, BoardRest).

generalToBoardCoords(InGeneralLine, InGeneralCol, OutBoardLine, OutBoardCol, OutBoardX, OutBoardY):-
    (InGeneralLine > 4,
        (OutBoardLine = InGeneralLine - 4, OutBoardY = 2);
        (OutBoardLine = InGeneralLine, OutBoardY = 1)),
    (InGeneralCol > 4,
        (OutBoardCol = InGeneralCol - 4, OutBoardX = 2);
        (OutBoardCol = InGeneralCol, OutBoardX = 1)).
