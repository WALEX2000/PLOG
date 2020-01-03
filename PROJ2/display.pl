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

%Writes a Char a Total number of times
writeRepeat(_, 0).
writeRepeat(Char, Total):-
    print(Char),
    NewT is Total - 1,
    writeRepeat(Char, NewT).

%Prints The Root of the Tree
printRoot(Total):-
    writeRepeat('     ', Total),
    print('  |'), nl.

getRightMostChild([Elem|[]], Elem).
getRightMostChild([_|Rest], RightMostChild):-
    getRightMostChild(Rest, RightMostChild).

getLeftMostWeight([], 1000000). %Really big number to ensure success in case there are no weights left
getLeftMostWeight([Elem/Pos|_], LeftMostWeight):-
    isWeight(Elem), LeftMostWeight = Pos, !.
getLeftMostWeight([Elem|Rest], LeftMostWeight):-
    \+isWeight(Elem),
    getLeftMostWeight(Rest, LeftMostWeight).

%Check if Subtree can begin there or needs to go down more
checkIfSubtreeValid(Subtree/RootGP, CurrPos, Rest):-
    Subtree = [LeftChild|OtherNodes],
    LeftChild = (LeftChildPos|_),
    LeftChildGP is RootGP + LeftChildPos, LeftChildGP > CurrPos,
    %Now check if rightMostChild is in conflict with LeftMostWeight
    getRightMostChild(OtherNodes, RightMostChild),
    getLeftMostWeight(Rest, WeightPos),
    RightMostChild = (RightChildPos|_),
    RightChildGP is RootGP + RightChildPos, RightChildGP < WeightPos.

isWeight(Node):- var(Node).
isWeight(Node):- number(Node).

printMargin(Margin):- writeRepeat('     ', Margin).

printRow([Elem|Rest], RootGP, CurrPos, ExtraSpace):-
    Elem = (FirstPos|_),
    FirstGP is RootGP + FirstPos,
    WS is FirstGP - CurrPos - 1,
    writeRepeat('     ', WS),
    Space is 4 - ExtraSpace, writeRepeat(' ', Space),
    print('+'),
    printRowRest(Rest, FirstPos).

printRowRest([], _).
printRowRest([Elem|Rest], LastPos):-
    Elem = (CurrPos|_),
    Spaces is CurrPos - LastPos - 1,
    writeRepeat('----|', Spaces),
    print('----+'),
    printRowRest(Rest, CurrPos).

%Prints the bottom side of a Row
printRowBottom([Elem|Rest], LastPos):-
    Elem = (CurrPos|Node),
    ((isWeight(Node),
      WS is LastPos + CurrPos - 1,
      writeRepeat('     ', WS),
      print(' _|_ '),
      printRowBottomRest(Rest, CurrPos)
     );
     (WS is LastPos + CurrPos,
     writeRepeat('     ', WS),
     print('|'),
     printRowBottomRest(Rest, CurrPos))).

printRowBottomRest([], _).
printRowBottomRest([Elem|Rest], LastPos):-
    Elem = (CurrPos|Node),
    ((isWeight(Node),
      Spaces is CurrPos - LastPos - 1,
      writeRepeat('     ', Spaces),
      print('   _|_ '),
      printRowBottomRest(Rest, CurrPos));
     (Spaces is CurrPos - LastPos - 1, 
      writeRepeat('     ', Spaces),
      print('    |'),
      printRowBottomRest(Rest, CurrPos))).

digits(X,1):-10>X,X>0.
digits(X,Y):-A=X/10,digits(A,B),Y=B+1.

printWeight(WeightValue, WeightGP, CurrentPosition, ExtraSpace, WeightGP, 2):-
    Offset is WeightGP - CurrentPosition - 1,
    writeRepeat('     ', Offset),
    Space is 2 - ExtraSpace, writeRepeat(' ', Space),
    ((number(WeightValue), print('|'), digits(WeightValue, Ndigits), S is 3 - Ndigits, FS is floor(S/2), LS is S - FS,
      writeRepeat(' ', LS), print(WeightValue), writeRepeat(' ', FS), print('|'));
     (print('|???|'))). %Print node if it's unknown

%For printing Subtrees
printNode(Subtree, RootGP, CurrentPosition, ExtraSpace, NewPos, 0):-
    printRow(Subtree, RootGP, CurrentPosition, ExtraSpace),
    getRightMostChild(Subtree, Child),
    Child = (LocalPos|_), NewPos is LocalPos + RootGP.

printStem(Node, RootGP, CurrPos, ExtraSpace, RootGP, 1):- %For weights
    isWeight(Node),
    WS is RootGP - CurrPos - 1, writeRepeat('     ', WS),
    Spaces is 3 - ExtraSpace, writeRepeat(' ', Spaces),
    print('_|_').

printStem(_, RootGP, CurrPos, ExtraSpace, RootGP, 0):- %For Subtrees
    WS is RootGP - CurrPos - 1, writeRepeat('     ', WS),
    Spaces is 4 - ExtraSpace, writeRepeat(' ', Spaces),
    print('|').

%Prints a line of Subtrees and weights (Subtrees can be invalid and thus need to go down more)
printLine([], _, _, List, List):- nl.
printLine([Node/RootGP|Rest], CurrPos, ExtraSpace, TmpList, NewList):- %If Node is weight
    isWeight(Node),
    printWeight(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    printLine(Rest, NewPos, NewExtraSpace, TmpList, NewList).

printLine([Node/RootGP|Rest], CurrPos, ExtraSpace, TmpList, NewList):- %If node is Valid Subtree
    checkIfSubtreeValid(Node/RootGP, CurrPos, Rest),
    addChildrenToList(Node, RootGP, TmpList, NewTmpList),
    printNode(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    printLine(Rest, NewPos, NewExtraSpace, NewTmpList, NewList).

printLine([Node/RootGP|Rest], CurrPos, ExtraSpace, TmpList, NewList):- %If node is invalid Subtree
    append(TmpList, [Node/RootGP], NewTmpList),
    WS is RootGP - CurrPos - 1,
    %trace,
    writeRepeat('     ', WS),
    Space is 4 - ExtraSpace, writeRepeat(' ', Space),
    print('|'),
    printLine(Rest, RootGP, 0, NewTmpList, NewList).

addChildrenToList([], _, ResultList, ResultList).
addChildrenToList([Child|Rest], RootGP, TmpList, ResultList):-
    Child = (Pos|Node), PosGP is Pos + RootGP,
    append(TmpList, [Node/PosGP], NewTmp),
    addChildrenToList(Rest, RootGP, NewTmp, ResultList).

printLineBottom([], _, _):- nl.
printLineBottom([Node/NodeGP|Rest], CurrPos, ExtraSpace):-
    printStem(Node, NodeGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    printLineBottom(Rest, NewPos, NewExtraSpace).

%Loop for printing entire tree
printTreeLoop([], _).
printTreeLoop(Line, Margin):-
    printMargin(Margin),
    printLine(Line, -1, 2, [], NewLine),
    printMargin(Margin),
    printLineBottom(NewLine, -1, 2),
    printTreeLoop(NewLine, Margin).

runLine([], _, _, List, List, _).
runLine([Node/RootGP|Rest], CurrPos, ExtraSpace, TmpList, NewList, _):- %If Node is weight
    isWeight(Node),
    runWeight(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    runLine(Rest, NewPos, NewExtraSpace, TmpList, NewList, _).

runLine([Node/RootGP|Rest], CurrPos, ExtraSpace, TmpList, NewList, _):- %If node is Valid Subtree
    checkIfSubtreeValid(Node/RootGP, CurrPos, Rest),
    addChildrenToList(Node, RootGP, TmpList, NewTmpList),
    runNode(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace, WS),
    runLine(Rest, NewPos, NewExtraSpace, NewTmpList, NewList, WS).

runLine([Node/RootGP|Rest], CurrPos, _, TmpList, NewList, Node/RootGP):- %If node is invalid Subtree
    WS is RootGP - CurrPos - 1, WS < 0
    append(TmpList, [Node/RootGP], NewTmpList),
    runLine(Rest, RootGP, 0, NewTmpList, NewList, WS).

runLine([Node/RootGP|Rest], CurrPos, _, TmpList, NewList, WS):- %If node is invalid Subtree
    WS is RootGP - CurrPos - 1,
    append(TmpList, [Node/RootGP], NewTmpList),
    runLine(Rest, RootGP, 0, NewTmpList, NewList, WS).

runWeight(_, WeightGP, _, _, WeightGP, 2).

%For printing Subtrees
runNode(Subtree, RootGP, CurrentPosition, _, _, 0, WS):-
    Subtree = [(FirstPos|_)|_], FirstGP is RootGP + FirstPos,
    WS is FirstGP - CurrentPosition - 1, WS < 0.

%For printing Subtrees
runNode(Subtree, RootGP, _, _, NewPos, 0, _):-
    getRightMostChild(Subtree, Child),
    Child = (LocalPos|_), NewPos is LocalPos + RootGP.

%ELIMINATE IF GOOD
runRow([Elem|Rest], RootGP, CurrPos, ExtraSpace):-
    Elem = (FirstPos|_),
    FirstGP is RootGP + FirstPos,
    WS is FirstGP - CurrPos - 1,
    writeRepeat('     ', WS),
    Space is 4 - ExtraSpace, writeRepeat(' ', Space),
    print('+'),
    runRowRest(Rest, FirstPos).

runRowRest([], _).
runRowRest([Elem|Rest], LastPos):-
    Elem = (CurrPos|_),
    Spaces is CurrPos - LastPos - 1,
    writeRepeat('----|', Spaces),
    print('----+'),
    printRowRest(Rest, CurrPos).

runStem(Node, RootGP, _, _, RootGP, 1):- %For weights
    isWeight(Node).

runStem(_, RootGP, _, _, RootGP, 0).

runLineBottom([], _, _).
runLineBottom([Node/NodeGP|Rest], CurrPos, ExtraSpace):-
    runStem(Node, NodeGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    runLineBottom(Rest, NewPos, NewExtraSpace).

%Used to check if there's an impossible print happening
runTreeLoop([], _).
runTreeLoop(Line, InvalidSubTree):-
    runLine(Line, -1, 2, [], NewLine, InvalidSubTree),
    ((\+var(InvalidSubTree));
     (runLineBottom(NewLine, -1, 2),
     runTreeLoop(NewLine, SpacesToMult))).

multTree([], _, []).
multTree([(Pos|Node)|Rest], Mult, NewTree):-
    NewPos is Pos * -Mult,
    NewTree = [(NewPos|Node)|Others],
    multTree(Rest, Mult, Others).

findParentTree(Tree, InvalidSubTree, ParentTree):-
    

correctTree(Tree, NewTree):-
    getLeftMostPosition(Tree, LeftMostValue),
    RootGlobalPosition is abs(LeftMostValue),
    runTreeLoop([Tree/RootGlobalPosition], InvalidSubTree),
    ((var(InvalidSubTree), NewTree = Tree);
     (findParentTree(Tree, InvalidSubTree, ParentTree) multTree(Tree, Mult, BetterTree), correctTree(BetterTree, NewTree))).

%Main Function to print tree
printTree(Tree):-
    Margin = 1,
    correctTree(Tree, NewTree),
    getLeftMostPosition(NewTree, NewLeftMostValue),
    NewRootGlobalPosition is abs(NewLeftMostValue),
    nl,
    printMargin(Margin),
    printRoot(NewRootGlobalPosition),
    printTreeLoop([NewTree/NewRootGlobalPosition], Margin).

% consult('display.pl'), complexTree(Tree), printTree(Tree).