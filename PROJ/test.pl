hi(a, b).
hi(c, d).
hi(a, d).

:-use_module(library(ansi_term)).

doStuff():-
    ansi_format([bold,bg('#fbff1f'),fg(black)], ' ● ', []).