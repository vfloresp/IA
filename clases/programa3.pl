%valor_max(i,i,o):  input o instantiated  , output o open
valor_max(X,Y,X):-
    X>Y.
valor_max(X,Y,Y):-
    X=<Y.

