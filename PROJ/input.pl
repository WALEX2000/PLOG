readPlay(Line, Col, BoardSize):-
    read_line_to_codes(user_input, Codes),
    string_codes(String, Codes),
    atom_chars(String, Chars),
    nth0(0, Chars, ColChar),
    char_code(ColChar, ColNum),
    Col is ColNum-65,
    Col@>=0,
    Col@<BoardSize,
    nth0(1, Chars, LineChar),
    atom_number(LineChar, LineNum),
    Line is LineNum - 1,
    Line@>=0,
    Line@<BoardSize.