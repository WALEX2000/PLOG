% consult('display.pl').
:-consult('trees.pl').
:-use_module(library(lists)).

%Gets the biggest amount of spacing necessary (for root)
getLeftMostPosition(Tree, LeftMostValue):-
    Tree = [FirstElem|_],
    FirstElem = (Pos|_),
    depthSearch(Tree, 0, Pos, LeftMostValue).

%In case we called depthSearch on a Leaf
depthSearch(NotAList, Tmp, LeftMostTmp, LeftMostValue):-
    \+is_list(NotAList),
    ((Tmp < LeftMostTmp, LeftMostValue = Tmp);
    (Tmp >= LeftMostTmp, LeftMostValue = LeftMostTmp)).
depthSearch([], _, _, _).
%DFS search
depthSearch([FirstElem|Rest], Tmp, LeftMostTmp, LeftMostValue):-
    FirstElem = (Pos|Children),
    NewTmp is Tmp + Pos,
    depthSearch(Children, NewTmp, LeftMostTmp, NewLeftMostTmp),
    depthSearch(Rest, 0, NewLeftMostTmp, LeftMostValue),
    LeftMostValue = NewLeftMostTmp.

%Main Functiono to print tree
printTree:-
    complexTree(Tree),
    getLeftMostPosition(Tree, LeftMostValue),
    print(LeftMostValue).