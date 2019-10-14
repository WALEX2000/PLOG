factorial(0, 1).
factorial(1, 1).

factorial(N, Valor) :-
    N > 1,
    N1 is N-1, factorial(N1, V1),
    Valor is N*V1.