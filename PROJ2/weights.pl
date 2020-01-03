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
    getTorques(Tree, Torque),
    Torque #= 0,
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
treeWeightsList([(Pos|Subtree)|Rest], TotalWeights):- %For subtrees
    is_list(Subtree),
    Pos #\= 0,
    treeWeightsList(Subtree, SubtreeWeights),
    append(SubtreeWeights, Weights, TotalWeights),
    treeWeightsList(Rest, Weights).
treeWeightsList([(Pos|Node)|Rest], [Node|RestWeights]):- %For regular weights
    (\+is_list(Node)),
    Pos #\= 0,
    treeWeightsList(Rest, RestWeights).

getTorques([], 0).
getTorques([(Pos|Node)|Rest], Torque):-
    getNodeTorque(Pos, Node, NodeTorque),
    NewTorque #= Torque - NodeTorque,
    getTorques(Rest, NewTorque).

getNodeTorque(Pos, Value, Torque):-
    (\+is_list(Value)),
    Torque #= Pos * Value.
getNodeTorque(Pos, Subtree, Torque):-
    is_list(Subtree),
    solveTree(Subtree, SubtreeWeight),
    Torque #= Pos * SubtreeWeight.

getTotalWeight(0, Total, Total).
getTotalWeight(Nweights, Tmp, Total):-
    NewTmp is Tmp + Nweights,
    NewN is Nweights - 1,
    getTotalWeight(NewN, NewTmp, Total).

labelNextSubtree([]).
labelNextSubtree([(_|Node)|Rest]):-
    is_list(Node),
    labelRow(Node),
    labelNextSubtree(Node),
    labelNextSubtree(Rest).
labelNextSubtree([(_|_)|Rest]):- labelNextSubtree(Rest).

labelPuzzlePos([]).
labelPuzzlePos(Puzzle):-
    labelRow(Puzzle),
    labelNextSubtree(Puzzle).

labelRow([], Nodes):- length(Nodes, Length), NegLength is Length * -1, domain(Nodes, NegLength, Length).
labelRow([(Pos|_)|Rest], Nodes):-
    Nodes = [PrevPos|_],
    Pos #> PrevPos,
    labelRow(Rest, [Pos|Nodes]).

labelRow([(Pos|_)|Rest]):-
    labelRow(Rest, [Pos]).

%Go through every node in list and turn into a weight or a sublist
assignForm([], Remaining, Remaining).
assignForm([(_|Node)|Rest], Remaining, NewRemaining):-
    (Remaining > 0, random(0,2, Choice), %If subtrees are still needed choose randomly between Subtree or weight
     (
      (Choice = 0, assignForm(Rest, Remaining, NewRemaining)); %In case of weight just go to the next node on this row
      (Choice = 1, Node = [_], Rem is Remaining - 1, assignForm(Rest, Rem, NewRemaining)) %If case of subtree create list, sub to Remaining and go to next node
     )
    );
    (Remaining = 0, assignForm(Rest, Remaining, NewRemaining)); %If subtrees aren't needed just leave as weight
    (Remaining > 0, Node = [_], Rem is Remaining - 1, assignForm(Rest, Rem, NewRemaining)). %In the rare case that random only selected weights but subtrees are still needed.

getNextLine([], []).
getNextLine([(_|Node)|Rest], NewLine):-
    (is_list(Node), Node = [SubTree], NewLine = [SubTree|Other], getNextLine(Rest, Other)); %If node is a subTree
    (Node = _, getNextLine(Rest, NewLine)). %If node is a weight
getNextLine([List|Rest], NewLine):- %If we get a list of lists
    getNextLine(List, LinePart),
    getNextLine(Rest, Other),
    append(LinePart, Other, NewLine).

generateStructure([], NextLineRemaining, NextLineRemaining).
generateStructure([SubTree|Rest], Nweights, NextLineRemaining):-
    N is Nweights + 2,
    Tmp is N + 1,
    random(2, Tmp, Nnodes), %Create a random amount of nodes
    length(SubTree, Nnodes), %Turn Subtree Node into a list with Nnodes
    Remaining is N - Nnodes,
    assignForm(SubTree, Remaining, NewRemaining), %NewRemaining accounts for sublists
    generateStructure(Rest, NewRemaining, NextLineRemaining).

%Ends when next line is empty and remaining = 0
generateNextLine([], 0).
generateNextLine(Puzzle, WeightsNeeded):-
    length(Puzzle, L), L > 0,
    generateStructure(Puzzle, WeightsNeeded, NextLineWeightsNeeded),
    getNextLine(Puzzle, NextLine),
    generateNextLine(NextLine, NextLineWeightsNeeded).

%Create a valid randomly created structure for our puzzle
generateStructure(Puzzle, Nweights):-
    Tmp is Nweights + 1,
    random(2, Tmp, Nnodes), %Create a random amount of nodes
    length(Puzzle, Nnodes), %Turn Puzzle into a list of Nnodes
    Remaining is Nweights - Nnodes,
    assignForm(Puzzle, Remaining, NewRemaining), %NewRemaining accounts for sublists
    getNextLine(Puzzle, NextLine),
    generateNextLine(NextLine, NewRemaining).

rectifyNode((_|Val), NewNode):- %If it is a list
    is_list(Val), Val = [NL],
    removeDoubleLists(NL, RectifiedList),
    NewNode = (_|RectifiedList).
rectifyNode(N, N).

removeDoubleLists([], []).
removeDoubleLists([Node|Rest], Puzzle):-
    rectifyNode(Node, NewNode),
    Puzzle = [NewNode|OtherNodes],
    removeDoubleLists(Rest, OtherNodes).

getPuzzlePositions([], []).
getPuzzlePositions([(Pos|Node)|Rest], PosList):-
    \+isWeight(Node),
    PosList = [Pos|List],
    getPuzzlePositions(Node, DepthList),
    getPuzzlePositions(Rest, NextList),
    append(DepthList, NextList, List).
getPuzzlePositions([(Pos|Node)|Rest], PosList):-
    isWeight(Node),
    PosList = [Pos|List],
    getPuzzlePositions(Rest, List).

%Create a puzzle and get its solution given a number of weights in that puzzle
createPuzzle(Nweights, Puzzle, Solution):-
    length(Solution, Nweights), %set size of Solution
    domain(Solution, 1, Nweights), %set domain of solution
    all_distinct(Solution), %specify solution is distinct
    getTotalWeight(Nweights, 0, TotalWeight),
    generateStructure(TmpPuzzle, Nweights), %Generate puzzle structure
    removeDoubleLists(TmpPuzzle, Puzzle), %Remove double lists inserted in generate puzzle (No other way around this)
    treeWeightsList(Puzzle, Solution), %Bind solution to puzzle nodes
    labelPuzzlePos(Puzzle), %assign further restrictions
    solveTree(Puzzle, TotalWeight), %assign restrictions
    print(Puzzle), nl,
    %labelPuzzlePos(Puzzle), %assign further restrictions
    print('Oi2'), nl,
    getPuzzlePositions(Puzzle, Pos), %get all positions and append to solution
    append(Solution, Pos, Vars),
    print('Oi3'), nl,
    labeling([bisect, ffc], Vars).

% consult('weights.pl'), tree5(Tree), start(Tree, Weight).
% consult('weights.pl'), tree8(Tree), start(Tree, Weight).
% consult('weights.pl'), testTree(Tree), start(Tree, Weight).
% consult('weights.pl'), createPuzzle(5, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(2, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(3, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(4, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(15, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(20, Puzzle, Solution), printTree(Puzzle).
% consult('weights.pl'), createPuzzle(8, Puzzle, Solution), printTree(Puzzle).