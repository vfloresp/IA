:-dynamic matriz/3.

matriz([1,2,3],1,3).

%Recibe una lista y regresa su longitud.
longitud([],0).
longitud([_|Cola],Long+1):-
         longitud(Cola,Long).

%Recibe dos listas y realiza la comparación de sus longitudes
comparaLong(ListaA,ListaB):-
    longitud(ListaA,X),
    L1 is X,
    longitud(ListaB,Y),
    L2 is Y,
    L1 =:= L2.

%Predicados para la suma

%Realiza la suma elemento a elemento entre las listas
%cosidera que recibe listas sin listas internas, solo números
sumaLista([],[],[]).
sumaLista([A|ColaA],[B|ColaB],[C|ColaC]):-
         comparaLong(ColaA,ColaB),
         sumaLista(ColaA,ColaB,ColaC),
         C is A + B.

% Manda a llamar recursivamente sumaLista para cada para de listas
% (renglones) que se van a sumar en la matriz.
suma([],[],[]).
suma([A|ColaA],[B|ColaB],[C|ColaC]):-
    comparaLong(ColaA,ColaB),
    sumaLista(A,B,C),
    suma(ColaA,ColaB,ColaC).

%Predicados para la resta

% Similarmente a la suma, resta elemento a elemento de dos listas que no
% contienen listas interiores.
restaLista([],[],[]).
restaLista([A|ColaA],[B|ColaB],[C|ColaC]):-
         comparaLong(ColaA,ColaB),
         restaLista(ColaA,ColaB,ColaC),
         C is A - B.

% Utiliza el metod de restaLista para ir restando los renglones
% correspondientes.
resta([],[],[]).
resta([A|ColaA],[B|ColaB],[C|ColaC]):-
    comparaLong(ColaA,ColaB),
    restaLista(A,B,C),
    resta(ColaA,ColaB,ColaC).

%Metodos para la transposición

% Recibe una lista y cada uno de sus elementos lo guarda dentro de una
% lista propia. En otras palabreas, pasa de renglon a fila.
listaXelem([],[]).
listaXelem([A|ColaA],[B|ColaB]):-
         listaXelem(ColaA,ColaB),
         B = [A].

% Despues de haber transpuesto el primer renglon de la matriz, va
% transponiendo el resto de los renglones y llama pegaElem para unirlos
% con los elementos previos.
rellenaLista([],A,B):-
         B=A.
rellenaLista([A|ColaA],[B|ColaB],C):-
         listaXelem(A,X),
         pegaElem([B|ColaB],X,Z),
         rellenaLista(ColaA,Z,C).

% Recibe dos listas que contienen listas a su vez y elemento a elemento
% va concatenando las listas. Esto crea los nuevos renglones
pegaElem([],[],[]).
pegaElem([A|ColaA],[B|ColaB],[C|ColaC]):-
         pegaElem(ColaA,ColaB,ColaC),
         append(A,B,C).

% transpone el primer elemento de las lista y manda llamar rellena Lista
% para que haga el proceso con el resto de la matriz.
transpone([A|ColaA],B):-
         listaXelem(A,X),
         rellenaLista(ColaA,X,B).

%Predicados para la multiplicación


multiplicaRenglones([],[],[]).
multiplicaRenglones([A|[]],[B|[]],C):-
         multiplicaLista(A,B,Z),
         sumaListaInterna(Z,C).
multiplicaRenglones([A|[]],[B|ColaB],[C|ColaC]):-
         multiplicaRenglones([A|[]],[B|[]],C),
         multiplicaRenglones([A|[]],ColaB,ColaC).

multiplicaRenglones([A|ColaA],[B|ColaB],[C|ColaC]):-
         multiplicaRenglones([A|[]],[B|ColaB],C),
         multiplicaRenglones(ColaA,[B|ColaB],ColaC).


% Transpone la segunda matriz para así poder operar las listas de forma
% más directa
multiplica([A|ColaA],[B|ColaB],C):-
         transpone([B|ColaB],[X|ColaX]),
         comparaLong(A,X),
         multiplicaRenglones([A|ColaA],[X|ColaX],C),!.

% Recibe dos listas y en la tercera devuelve la multiplicación elemento
% a elemento.
multiplicaLista([],[],[]).
multiplicaLista([A|ColaA],[B|ColaB],[C|ColaC]):-
         multiplicaLista(ColaA,ColaB,ColaC),
         C is A * B.

% Recibe una lista y suma todos sus elementos para regresar un unico
% valor.
sumaListaInterna([],0).
sumaListaInterna([A|ColaA],B):-
         sumaListaInterna(ColaA,X),
         B is X + A.

