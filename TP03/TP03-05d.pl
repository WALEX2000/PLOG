nesimo([Nesimo|Resto], 1, Nesimo).

nesimo([_|Lista], Indice, Nesimo):-
    N is Indice-1,
    nesimo(Lista, N, Nesimo).