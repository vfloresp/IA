:-dynamic matriz/3.

matriz([1,2,3],1,3).

longitud([],0).
longitud([_|Cola],Long+1):-
         longitud(Cola,Long).

comparaLong(ListaA,ListaB):-
    longitud(ListaA,X),
    L1 is X,
    longitud(ListaB,Y),
    L2 is Y,
    L1 =:= L2.

suma([[]|A],[[]|B],[_|C]):-
    C is A + B.
suma([A|ColaA],[B|ColaB],[C|ColaC]):-
    comparaLong(A,B),
    suma(A,B,C),
    suma(ColaA,ColaB,ColaC).

