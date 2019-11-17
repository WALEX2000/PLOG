

append1([],L,L).
append1([X|Rest1], L, [X|Rest2]):-
    append(Rest1,L,Rest2).

inverter(List, Reverse):-
    rev(List, [], Reverse).

rev([Head|Tail], List, Reverse):-
    rev(Tail, [Head|List], Reverse).
rev([], Reverse, Reverse).

membro(X, [X|_]).
membro(X, [_|R]):-
    membro(X,R).

membro2(X, L):-
    append(_, [X|_], L).

last1(L, X):-
    append(_, [X], L).

nth(1, [X|_], X).
nth(N, [_|L], X):-
    N>1,
    N1 is N-1,
    nth(N1, L, X).

delete_one(X, L1, L2):-
    append(La, [X|Lb], L1),
    append(La, Lb, L2).

delete_all(_, [], []).
delete_all(X, [X|L1], L2):-
    delete_all(X, L1, L2).
delete_all(X, [Y|L1], [Y|L2]):-
    delete_all(X, L1, L2).

delete_all_list([], L, L).
delete_all_list([H|L], L1, L2):-
    delete_all(H, L1, L2),
    delete_all_list(L, L1, L2).

before(A,B,L):-
    append(_,[A|L1],L),
    append(_,[B|_],L1).

conta([],0).
conta([_|R], N):-
    N1 is N-1,
    conta(R,N1).

conta_elem(_, [], 0).
conta_elem(X, [X|R], N):-
    N1 is N-1,
    conta_elem(X, R, N1).
conta_elem(X, [Y|R], N):-
    X\=Y,
    conta_elem(X,R,N).

substitui(_,_,[],[]).
substitui(X,Y,[X|L1],[Y|L2]):-
    substitui(X,Y,L1,L2).
substitui(X,Y,[Z|L1],[Z|L2]):-
    Z\=X,
    substitui(X,Y,L1,L2).

elimina_duplicados([], []).
elimina_duplicados([H|R], [H|L2]):-
    delete_all(H,R,L),
    elimina_duplicados(L, L2).

ordenada([_]).
ordenada([N1,N2]):-
    N1@=<N2.
ordenada([N1,N2|Resto]),
    N1@=<N2,
    ordenada[N2|Resto].




