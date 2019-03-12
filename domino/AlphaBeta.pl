%Base de datos con la notaci�n de [[6,6], costo]

listaAbierta([X,Y]).
listaFichas([[6,6],_],[[5,6],_],[[4,6],_],[[3,6],_],[[2,6],_],[[1,6],_],[[0,6],_],[[5,5],_],[[4,5],_],[[3,5],_],[[2,5],_],[[1,5],_],[[0,5],_],[[4,4],_],[[3,4],_],[[2,4],_],[[1,4],_],[[0,4],_],[[3,3],_],[[2,3],_],[[1,3],_],[[0,3],_],[[2,2],_],[[1,2],_],[[0,2],_],[[1,1],_],[[0,1],_],[[0,0],_]).
listaEnMano().
listaEnMesa().
NumComer(14).
miMano(N).
manoOponente(M).

listaIncognitas([],_,_,_):-
    !.
listaIncognitas(ListaFichas,ListaEnMano,ListaEnMesa,ListaIncognitos):-
    ListaFichas = [CabezaF|ColaF],
    (member(CabezaF,ListaEnMano) == false ->
    append(CabezaF,ListaIncognitos,ListaIncognitos)),
    (member(CabezaF,ListaEnMesa)== false ->
    append(CabezaF,ListaIncognitos,ListaIncognitos)),
    listaIncognitas(ColaF,ListaEnMano,ListaEnMesa,ListaIncognitos).

%EjemploArbol is [[6,6],[[6,5],[6,4]]].%
%BaseDatos is [[6,6],[5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[5,5],[4,5],[3,5],[2,5],[1,5],[0,5],[4,4],[3,4],[2,4],[1,4],[0,4],[3,3],[2,3],[1,3],[0,3],[2,2],[1,2],[0,2],[1,1],[0,1],[0,0]].%
%Abierto is lista de 2.%
%Incognitas is lista de piezas que no sabemos.%
%MiJuego is  lista de fichas que yo tengo.%

% Arbol is arbol que vamos a estar generando en el momento - se va a%
% estar generan%do en cada turno.%

alphaBeta([[_,Val]|[]],_,_,_,_,ValorH):-
    ValorH is Val,!.

alphaBeta([[[_,Val]|[]]],_,_,_,_,ValorH):-
    ValorH is Val,!.

alphaBeta([_|Node],0,_,_,_,ValorH):-
    ValorH is Node,!.

alphaBeta([_,[Children]|Cuerpo],Depth,Alpha,Beta,Player,ValorH):-
   alphaBeta(Children,Depth,Alpha,Beta,Player,ValorH),
   alphaBeta(Cuerpo,Depth,Alpha,Beta,Player,ValorH),!.

alphaBeta([_|[Children]],Depth,Alpha,Beta,1,ValorH):-
    Value is -5000,
    forEachAlpha(Children,Value,Depth,Alpha,Beta,ValorH),!.

alphaBeta([_|Children],Depth,Alpha,Beta,0,ValorH):-
    Value is 5000,
    forEachBeta(Children,Value,Depth,Alpha,Beta,ValorH).


forEachAlpha(_,_,_,Alpha,Beta,_):-
    Alpha >= Beta,fail.

forEachAlpha([Child1|[]],Value,Depth,Alpha,Beta,ValueRet):-
     childrenMax(Child1,Value,Depth,Alpha,Beta,ValueRet),!.

forEachAlpha([Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet):-
    childrenMax(Child1,Value,Depth,Alpha,Beta,ValueRes),
    forEachAlpha(Childrens,Value,Depth,ValueRes,Beta,ValueRet),!.


forEachBeta(_,_,_,Alpha,Beta,_):-
    Alpha >= Beta,fail.

forEachBeta([Child1|[]],Value,Depth,Alpha,Beta,ValueRet):-
     childrenMin(Child1,Value,Depth,Alpha,Beta,ValueRet).

forEachBeta([Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet):-
    childrenMin(Child1,Value,Depth,Alpha,Beta,ValueRes),
    forEachBeta(Childrens,Value,Depth,Alpha,ValueRes,ValueRet),!.

maxim(Valor1,Valor2,Res):-
    Valor1>Valor2,
    Res is Valor1,!.

maxim(_,Valor2,Res):-
    Res is Valor2.

childrenMax(Children,Value,Depth,Alpha,Beta,ValueRet):-
    DepthN is Depth -1,
    alphaBeta(Children,DepthN,Alpha,Beta,0,ValorH),
    maxim(Value,ValorH,ValueRes),
    maxim(Alpha,ValueRes,AlphaN),
    ValueRet is AlphaN,!.

minmin(Valor1,Valor2,Res):-
    Valor1<Valor2,
    Res is Valor1,!.

minmin(_,Valor2,Res):-
    Res is Valor2.

childrenMin(Children,Value,Depth,Alpha,Beta,ValueRet):-
    DepthN is Depth -1,
    alphaBeta(Children,DepthN,Alpha,Beta,1,ValorH),
    minmin(Value,ValorH,ValueRes),
    minmin(Beta,ValueRes,AlphaN),
    ValueRet is AlphaN,!.

% Entran como parametros la lista del jugador y la lista de puntos
% abiertos del juego
%
tomaUna(_,0,Player):-
    Player is 0.

tomaUna(ListaEnMano,NumComer,Player):-
    read([[X,Y],Costo]),nl,
    append([[X,Y],Costo],ListaEnMano,ListaEnMano),
    b_set(NumComer,NumComer-1).

buscaAbierto([],_,_,_,_):-
    !.
buscaAbierto([CabezaLM|ColaLM],[X|Y],ListaJugada,ListaEnMano,NumComer,Player):-
    CabezaLM = [NumFicha|Peso],
    (member(X,NumFicha) ->
     NumFicha = [Num1|Num2],
     (Num1=:=Num2 -> Peso is Num1+Num2+13),
     (Num1=\=Num2 -> Peso is Num1+Num2),
     append(ListaJugada,CabezaLM,ListaJugada)),
    (((member(X,NumFicha),member(Y,NumFicha)) == false), member(Y,NumFicha) ->
     NumFicha = [Num1|Num2], Peso is Num1+Num2,
     append(ListaJugada,CabezaLM,ListaJugada)),

    ((member(X,NumFicha) == false);(member(Y,NumFicha) == false);((member(X,NumFicha),member(Y,NumFicha)) == false) ->
    tomaUna(ListaEnMano,NumComer,Player)),

    buscaAbierto(ColaLM,[X|Y],ListaJugada,ListaEnMano,NumComer,Player).

funcionYasAsi(ListaJugada,ListaAbietos,ListaJugada,ListaEnMano,NumComer,Depth,Alpha,Beta,Player,ValorH):-
    buscaAbierto(ListaJugada,ListaAbietos,ListaJugada,ListaEnMano,NumComer,Player),
    alphaBeta(ListaJugada,Depth,Alpha,Beta,Player,ValorH).

