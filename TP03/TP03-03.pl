join([], L, L).
join((X|L1), L2, (X|L)) :-
    join(L1,L2,L).
    