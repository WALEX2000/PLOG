readCell(Line, Col, BoardSize):-
    RealSize is BoardSize*2,
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes),
    atom_chars(String, Chars),
    nth0(0, Chars, LineChar),
    char_code(LineChar, LineNum),
    Line is LineNum-65,
    Line@>=0,
    Line@<RealSize,
    nth0(1, Chars, ColChar),
    atom_number(ColChar, ColNum),
    Col is ColNum - 1,
    Col@>=0,
    Col@<RealSize.

getPlayerMove(OrigLine, OrigCol, DestLine, DestCol, PlayerMoves, PiecePushed):-
    write("Origin (eg: A1):"),
    readCell(OrigLine, OrigCol, 4),
    write("Destination (eg: A1):"),
    readCell(DestLine, DestCol, 4),
    (member([OrigLine/OrigCol,DestLine/DestCol], PlayerMoves);
    member([[OrigLine/OrigCol,DestLine/DestCol], PiecePushed], PlayerMoves)).
getPlayerMove(_, _, _, _, _, _):-
    write("Invalid move.\n"),
    fail.