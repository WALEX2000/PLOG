hi(a, b).
hi(c, d).
hi(a, d).

% ansi_format([bg('#9c9898')], 'text', []).

:-use_module(library(ansi_term)).

doStuff():-
    ansi_format([bg('white'), fg('black')], ' ●  ○ ', []),
    ansi_format([bg('black'), fg('white')], ' ○  ● ', []).

%Problem, background colors aren't displaying outside of VSCode terminal