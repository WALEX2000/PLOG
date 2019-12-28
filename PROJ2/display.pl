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
    print('|'), nl.

getRightMostChild([Elem|[]], Elem).
getRightMostChild([Elem|Rest], RightMostChild):-
    getRightMostChild(Rest, RightMostChild).

getLeftMostWeight([], (1000000|_)). %Really big number to ensure success in case there are no weights left
getLeftMostWeight([Elem|Rest], LeftMostWeight):-
    isWeight(Elem), LeftMostWeight = Elem.

getLeftMostWeight([_|Rest], LeftMostWeight):-
    getLeftMostWeight(Rest).

%Check if Subtree can begin there or needs to go down more
checkIfSubtreeValid(Subtree, RightMostPos, Rest):-
    Subtree = [LeftChild|OtherNodes],
    LeftChild = (ChildPos|_), ChildPos >= RightMostPos,
    %Now check if rightMostChild is in conflict with LeftMostWeight
    getRightMostChild(OtherNodes, RightMostChild),
    getLeftMostWeight(Rest, LeftMostWeight),
    RightMostChild = (ChildPos|_),
    LeftMostWeight = (WeightPos|_),
    ChildPos < WeightPos, %The problem is that the ChildPos is relative to parent Tree and we need the global position here

printRowItems([Elem|Rest], TotalSpacing, RightMostPos):-
    Elem = (CurrPos|Node),
    %If it's a weight then print('|111|')
    ((isWeight(Node),
      WS is TotalSpacing + CurrPos - 1,
      writeRepeat('     ', WS), %Write white space until node is reached
      ((number(Node), print('|'), print(Node), print('|')); %Print node if it has numbers on it TODO add whitespace to make up total of 3 spaces with numbers
       (print('|???|'))), %Print node if it's unknown
      printRowItems(Rest, CurrPos) %Go to next node TODO fix
    );
    %If it's a subTree then evaluate if it's possible to place it here
        %Check if the leftmost Item overlaps with any weight or subtree on the left
        %Check if the RightMost overlaps with any weight
    (
     %Check if it's possible to "unwrap" the tree here
     checkIfSubtreeValid(Node, RightMostPos, Rest),
     %if it is then calculate the amount of spacing to get there and start printing like in the printRow thing, then go to next item
     %If it's not then calculate the spacing necessary and place a |. Then go to next item
     WS is TotalSpacing + CurrPos,
     writeRepeat('     ', WS),
     print('|'),
     printRowBottomRest(Rest, CurrPos))).
    %if all good then write like on the Row
    %If not then place a | instead
    %Will have to return a list with all the nodes on the next level (New Nodes or leftovers)
    
isWeight(Node):- var(Node).
isWeight(Node):- number(Node).

printMargin(Margin):- writeRepeat('     ', Margin).

printRow([Elem|Rest], RootGP):-
    Elem = (FirstPos|_),
    WS is RootGP + FirstPos,
    writeRepeat('     ', WS),
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

printRowBottomRest([], _):- nl.
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

%Node can be a weightValue or a List
printNode(WeightValue, WeightGP, CurrentPosition, ExtraSpace, WeightGP, 2):- %For Weights
    isWeight(WeightValue),
    printWeightSpacing, %Needs to check if there are any LeftOverSpaces and print the amount of spaces needed until this pos 
    ((number(WeightValue), print('|'), print(WeightValue), print('|')); %TODO add whitespace to make up total of 3 spaces with numbers
    (print('|???|'))), %Print node if it's unknown
    Left.

printNode(Subtree, RootGP, CurrentPosition, ExtraSpace, NewPos, 0):- %List (LIST might be impossible to print)
    printRow(Subtree, RootGP),
    getRightMostChild(Subtree, Child),
    Child = (NewPos|_).

printStem(Subtree, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace):-
    printRowBottom(Subtree, RootGP),
    getRightMostChild(Subtree, Child),
    Child = (NewPos|_).

%Prints a line of Subtrees and weights (Subtrees can be invalid and thus need to go down more)
printLine([], _, _):- nl.
printLine([Node/RootGP|Rest], CurrPos, ExtraSpace):-
    printNode(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    printLine(Rest, NewPos, NewExtraSpace).

printLineBottom([], _, _):- nl.
printLineBottom([Node/RootGP|Rest], CurrPos, ExtraSpace):-
    printStem(Node, RootGP, CurrPos, ExtraSpace, NewPos, NewExtraSpace),
    printLineBottom(Rest, NewPos, NewExtraSpace).

%Main Function to print tree
printTree:-
    complexTree(Tree),
    Margin = 1,
    getLeftMostPosition(Tree, LeftMostValue),
    RootGlobalPosition is abs(LeftMostValue),

    printMargin(Margin),
    printRoot(RootGlobalPosition),
    printMargin(Margin),
    printLine([Tree/RootGlobalPosition], 0, 0),
    printMargin(Margin),
    printLineBottom([Tree/RootGlobalPosition], 0, 0).

   % printRow(Tree, RootGlobalPosition), %TODO Needs to change the 2nd argument here
   % printMargin(Margin),
   % printRowBottom(Tree, RootGlobalPosition). %TODO Needs to change the 2nd argument here

% consult('display.pl'), printTree.