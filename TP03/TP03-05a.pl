membro(A, [A|_]).

membro(A, [_|L]) :-
    membro(A, L).