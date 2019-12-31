:-use_module(library(lists)).
:-use_module(library(clpfd)).
:-use_module(library(random)).
:-consult('trees.pl').
:-consult('display.pl').


start(Tree, Weight):-
    printTree(Tree), %Print the puzzle without solution
    treeWeightsList(Tree, Weights),
    length(Weights, Length),
    domain(Weights,1,Length),
    all_distinct(Weights),
    solveTree(Tree, Weight),!,
    labeling([], Weights),
    print('================================================================================='), nl,
    printTree(Tree), %Print the puzzle with solution
    write('Weights: '),
    write(Weights),
    nl.

solveTree(Tree, Weight):-
    getTorques(Tree, PosTorque, NegTorque),
    PosTorque #= NegTorque,
    treeWeight(Tree, Weight).

treeWeight([], 0).
treeWeight([(_|Subtree)|Rest], Weight):-
    is_list(Subtree),
    treeWeight(Subtree, SubtreeWeight),
    NewWeight #= Weight - SubtreeWeight,
    treeWeight(Rest, NewWeight).
treeWeight([(_|Node)|Rest], Weight):-
    (\+is_list(Node)),
    NewWeight #= Weight - Node,
    treeWeight(Rest, NewWeight).

treeWeightsList([], []).
treeWeightsList([(_|Subtree)|Rest], TotalWeights):-
    is_list(Subtree),
    treeWeightsList(Subtree, SubtreeWeights),
    append(SubtreeWeights, Weights, TotalWeights),
    treeWeightsList(Rest, Weights).
treeWeightsList([(_|Node)|Rest], [Node|RestWeights]):-
    (\+is_list(Node)),
    treeWeightsList(Rest, RestWeights).

getTorques([], 0, 0).
getTorques([(Pos|Node)|Rest], PosTorque, NegTorque):-
    Pos#>0,
    getNodeTorque(Pos, Node, NodeTorque),
    NewPosTorque #= PosTorque - NodeTorque,
    getTorques(Rest, NewPosTorque, NegTorque).
getTorques([(Pos|Node)|Rest], PosTorque, NegTorque):-
    Pos#<0,
    getNodeTorque(Pos, Node, NodeTorque),
    NewNegTorque #= NegTorque - NodeTorque,
    getTorques(Rest, PosTorque, NewNegTorque).

getNodeTorque(Pos, Value, Torque):-
    (\+is_list(Value)),
    Torque #= abs(Pos) * Value.
getNodeTorque(Pos, Subtree, Torque):-
    is_list(Subtree),
    solveTree(Subtree, SubtreeWeight),
    Torque #= abs(Pos) * SubtreeWeight.

sumAll([], Total, Total).
sumAll([Elem|Rest], Tmp, Total):-
    NewTmp #= Tmp + Elem,
    sumAll(Rest, NewTmp, Total).

getTotalWeight(0, Total, Total).
getTotalWeight(Nweights, Tmp, Total):-
    NewTmp is Tmp + Nweights,
    NewN is Nweights - 1,
    getTotalWeight(NewN, NewTmp, Total).

validPuzzle([], 0, 0).
validPuzzle([weight(Distance, Weight) | Puzzle], Torque, Total):-
    NewTorque #= Torque + Distance * Weight,
    validPuzzle(Puzzle, NewTorque, Subtotal),
    Total #= Subtotal + Weight.

validPuzzle([branch(Distance, Weights) | Puzzle], Torque, Total):-
    validPuzzle(Weights, 0, BranchWeight),
    NewTorque #= Torque + Distance * BranchWeight,
    validPuzzle(Puzzle, NewTorque, Subtotal),
    Total #= Subtotal + BranchWeight.

validPuzzle(Puzzle):- validPuzzle(Puzzle, 0, _).

validatePuzzle([], 0).
validatePuzzle([Elem|Rest], TotalTorque):-
    Elem = (Pos|Weight),
    Torque #= Pos * Weight,
    NewTotal #= TotalTorque + Torque,
    domain([Pos], -10, 10),
    labeling([], [Pos]),
    validatePuzzle(Rest, NewTotal).

validatePuzzle([Elem|Rest]):-
    Elem = (Pos|Weight),
    Torque #= Pos * Weight,
    random(-10, 10, Pos),
    domain([Pos], -10, 10),
    labeling([], [Pos]),
    validatePuzzle(Rest, Torque).

makeRowDistinct([], Nodes):- all_distinct(Nodes).
makeRowDistinct([(Pos|_)|Rest], Nodes):-
    Nodes = [NextPos|_],
    Pos #> NextPos,
    makeRowDistinct(Rest, [Pos|Nodes]).
makeRowDistinct([(Pos|_)|Rest]):-
    makeRowDistinct(Rest, [Pos]).
    

%Create a puzzle and get its solution given a number of weights in that puzzle
createPuzzle(Nweights, Puzzle, Solution):-
    length(Solution, Nweights), %set size of Solution
    domain(Solution, 1, Nweights), %set domain of solution
    all_distinct(Solution), %specify solution is distinct
    treeWeightsList(Puzzle, Solution),
    getTotalWeight(Nweights, 0, TotalWeight),
    print('TW: '), print(TotalWeight), nl,
    solveTree(Puzzle, TotalWeight),
    makeRowDistinct(Puzzle),
    validatePuzzle(Puzzle),
    labeling([], Solution).

% consult('weights.pl'), tree5(Tree), start(Tree, Weight).
% consult('weights.pl'), createPuzzle(5, Puzzle, Solution), printTree(Puzzle).