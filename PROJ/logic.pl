:-use_module(library(lists)).

valid_moves(Board, Player, ListOfMoves) :-
    setof([OrigLine, OrigCol, DestLine, DestCol], valid_move(Board, Player, OrigLine, OrigCol, DestLine, DestCol), ListOfMoves).

%Moves in horizontal line
%valid_move(Board, Player, OrigLine, OrigCol, OrigLine, DestCol) :-
    
valid_move(_,_,1,2,4,3).
/*valid_move(Board, Player, OrigLine, OrigCol, DestLine, DestCol).*/

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

switchTile(InBoard, OutBoard, BoardLine, BoardCol, Symbol, PastSymbol) :-
    nth0(1, InBoard, BoardPair, BoardRest), 
    nth0(1, BoardPair, SmallBoard, BoardPairRest),
    nth0(BoardLine, SmallBoard, SmallBoardLine, SmallBoardRest),
    nth0(BoardCol, SmallBoardLine, PastSymbol, SmallBoardLineRest),
    nth0(BoardCol, OutSmallBoardLine, Symbol, SmallBoardLineRest),
    nth0(BoardLine, OutSmallBoard, OutSmallBoardLine, SmallBoardRest),
    nth0(1, OutBoardPair, OutSmallBoard, BoardPairRest),
    nth0(1, OutBoard, OutBoardPair, BoardRest).
