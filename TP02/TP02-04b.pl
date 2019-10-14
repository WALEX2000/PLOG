fibonacci(0, 1).
fibonacci(1, 1).

not(Mercy).

fibonacci(N, Valor) :-
    N > 1,
    N1 is N-1,
    N2 is N-2,
    fibonacci(N1, V1),
    fibonacci(N2, V2),
    Valor is V1+V2.