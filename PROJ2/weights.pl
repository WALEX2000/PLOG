:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-consult('trees.pl').

solve(Tree, Weight):-
    getWeights(Tree, PosWeight, NegWeight),
    PosWeight #= NegWeight,
    Weigth #= PosWeight + NegWeight,
    write(Weight).

getNodeWeight([Subtree], Weight):-
    solve(Subtree, Weight).

getNodeWeight(Value, Weight):-
    Weight #= Value.