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

sumaLista([],[],[]).
sumaLista([A|ColaA],[B|ColaB],[C|ColaC]):-
         comparaLong(ColaA,ColaB),
         sumaLista(ColaA,ColaB,ColaC),
         C is A + B.

suma([],[],[]).
suma([A|ColaA],[B|ColaB],[C|ColaC]):-
    comparaLong(ColaA,ColaB),
    sumaLista(A,B,C),
    suma(ColaA,ColaB,ColaC).

restaLista([],[],[]).
restaLista([A|ColaA],[B|ColaB],[C|ColaC]):-
         comparaLong(ColaA,ColaB),
         restaLista(ColaA,ColaB,ColaC),
         C is A - B.

resta([],[],[]).
resta([A|ColaA],[B|ColaB],[C|ColaC]):-
    comparaLong(ColaA,ColaB),
    restaLista(A,B,C),
    resta(ColaA,ColaB,ColaC).

listaXelem([],[]).
listaXelem([A|ColaA],[B|ColaB]):-
         transpone(ColaA,ColaB),
         B = [A].

rellenaLista(_,[]).
rellenaLista([A|ColaA],[B|ColaB]):-
         A = [A,B]
         .

transpone([A|ColaA],B):-
         listaXelem(A,B),
         rellenaLista(B,ColaA).

