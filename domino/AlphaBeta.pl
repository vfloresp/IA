%Base de datos con la notaci�n de [[6,6], costo]

%listaAbierta([_,[_]]).
% consulta:
% alphaBeta([[[4,4],A],[[5,0],B],[[0,6],C],[[5,5],D],[[0,2],E],[[6,4],F],[[4,3],G]],[[[5,6],I],[[3,6],J],[[2,6],K],[[1,6],L],[[4,5],M],[[3,5],N],[[2,5],O],[[1,5],P],[[2,4],Q],[[1,4],R],[[0,4],S],[[3,3],T],[[2,3],U],[[1,3],V],[[0,3],W],[[2,2],X],[[1,2],Y],[[1,1],Z],[[0,1],ZZ],[[0,0],YY]],[6,6],[],3,[[],-5000],[[],5000],1,ValorH,7)
% listaFichas([[6,6],_],[[5,6],_],[[4,6],_],[[3,6],_],[[2,6],_],[[1,6],_],[[0,6],_],[[5,5],_],[[4,5],_],[[3,5],_],[[2,5],_],[[1,5],_],[[0,5],_],[[4,4],_],[[3,4],_],[[2,4],_],[[1,4],_],[[0,4],_],[[3,3],_],[[2,3],_],[[1,3],_],[[0,3],_],[[2,2],_],[[1,2],_],[[0,2],_],[[1,1],_],[[0,1],_],[[0,0],_]).
% listaEnMano(). listaEnMesa(). NumComer(14). miMano(N).
% manoOponente(M).

% listaIncognitas([],_,_,_):-
%     !.
% listaIncognitas(ListaFichas,ListaEnMano,ListaEnMesa,ListaIncognitos):-
%     ListaFichas = [CabezaF|ColaF],
%     (member(CabezaF,ListaEnMano) == false ->
%     append(CabezaF,ListaIncognitos,ListaIncognitos)),
%     (member(CabezaF,ListaEnMesa)== false ->
%     append(CabezaF,ListaIncognitos,ListaIncognitos)),
%     listaIncognitas(ColaF,ListaEnMano,ListaEnMesa,ListaIncognitos).

%EjemploArbol is [[6,6],[[6,5],[6,4]]].%
%BaseDatos is [[6,6],[5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[5,5],[4,5],[3,5],[2,5],[1,5],[0,5],[4,4],[3,4],[2,4],[1,4],[0,4],[3,3],[2,3],[1,3],[0,3],[2,2],[1,2],[0,2],[1,1],[0,1],[0,0]].%
%Abierto is lista de 2.%
%Incognitas is lista de piezas que no sabemos.%
%MiJuego is  lista de fichas que yo tengo.%

% Arbol is arbol que vamos a estar generando en el momento - se va a%
% estar generan%do en cada turno.%

% alphaBeta([[_,Val]|[]],_,_,_,_,ValorH):-
%     ValorH is Val,!.
%


alphaBeta([],_,_,Nodo,_,_,_,_,ValorH,_):-
    Nodo = [[Num1,Num2]|_],
    (Num1=:=Num2 ->
    Peso is Num1+Num2+13,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!);

    Nodo = [[Num1,Num2]|_],
    (Num1=\=Num2 -> Peso is Num1+Num2,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!).

alphaBeta(_,_,_,Nodo,0,_,_,_,ValorH,_):-
    Nodo = [[Num1,Num2]|_],
    (Num1=:=Num2 ->
    Peso is Num1+Num2+13,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!);

    Nodo = [[Num1,Num2]|_],
    (Num1=\=Num2 -> Peso is Num1+Num2,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!).

%alphaBeta(_,[],_,Nodo,_,_,_,_,ValorH,_):-
%    ValorH is Nodo,!.


alphaBeta(MisPiezas,Incognitas,Abiertas,[[Cab]|[]],Depth,Alpha,Beta,1,ValorH,Fcont):-
    generaArbol(MisPiezas,Abiertas,Hijos),
    (Hijos == [] ->
        (MisPiezas == []->
        ValorH = [[Cab]|550*Depth]);
        (ValorH = [[Cab]|0]) );
    generaArbol(MisPiezas,Abiertas,Hijos),
    alphaBeta(MisPiezas,Incognitas,Abiertas,[[]|Hijos],Depth,Alpha,Beta,0,ValorH,Fcont).

alphaBeta(MisPiezas,Incognitas,Abiertas, [[Cab]|[]],Depth,Alpha,Beta,0,ValorH,Fcont):-
    (Fcont =:= 0 ->
        ValorH = [[Cab]|-550*Depth]);
    generaArbol(Incognitas,Abiertas,Hijos),
    (Hijos == [] ->
        ValorH = [[Cab]|100*Depth]);
    generaArbol(MisPiezas,Abiertas,Hijos),
    alphaBeta(MisPiezas,Incognitas,Abiertas, [[]|Hijos],Depth,Alpha,Beta,1,ValorH,Fcont).

% alphaBeta([[[_,Val]|[]]],_,_,_,_,ValorH):-
%     ValorH is Val,!.

% alphaBeta([_|Node],0,_,_,_,ValorH):-
%     ValorH is Node,!.
%
% alphaBeta(MisPiezas,Incognitas,Abiertas,[],Depth,Alpha,Beta,1,ValorH,Fcont):-
 %   generaArbol(MisPiezas,Abiertas,Hijos),
  %  append([Abiertas],Hijos,Arbol),
   % (Arbol == [] -> write("No hay fichas hijos /n"));

  %  generaArbol(MisPiezas,Abiertas,Hijos),
  %  append([Abiertas],Hijos,Arbol),
  %  alphaBeta(MisPiezas,Incognitas,Abiertas,Arbol,Depth,Alpha,Beta,1,ValorH,Fcont).


alphaBeta(MisPiezas,Incognitas,Abiertas, [],Depth,Alpha,Beta,1,ValorH,Fcont):-
    generaArbol(MisPiezas,Abiertas,Hijos),
    append([Abiertas],Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,1,ValorH,Fcont).

alphaBeta(MisPiezas,Incognitas,Abiertas, [],Depth,Alpha,Beta,0,ValorH,Fcont):-
    generaArbol(Incognitas,Abiertas,Hijos),
    append([Abiertas],Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,0,ValorH,Fcont).

% alphaBeta(MisPiezas,Incognitas,Abiertas, [_,[Children]|Cuerpo],Depth,Alpha,Beta,Player,ValorH,Fcont):-
%     alphaBeta(MisPiezas,Incognitas,Abiertas, Children,Depth,Alpha,Beta,Player,ValorH),
%     alphaBeta(MisPiezas,Incognitas,Abiertas, Cuerpo,Depth,Alpha,Beta,Player,ValorH,Fcont),!.

alphaBeta(MisPiezas,Incognitas,Abiertas, [_|Children],Depth,Alpha,Beta,1,NValorH,Fcont):-
    Value = Alpha,
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValorH,Fcont,Camino),
    append([ValorH],Camino,NValorH),!.

alphaBeta(MisPiezas,Incognitas,Abiertas,[_|Children],Depth,Alpha,Beta,0,NValorH,Fcont):-
    Value = Beta,
    forEachBeta(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValorH,Fcont,Camino),
    append([ValorH],Camino, NValorH),!.


% alphaBeta(MisPiezas,Incognitas,Abiertas,[_,[Children]|Cuerpo],Depth,Alpha,Beta,Player,ValorH,Fcont):-
%    alphaBeta(MisPiezas,Incognitas,Abiertas,Children,Depth,Alpha,Beta,Player,ValorH,Fcont),
%    alphaBeta(MisPiezas,Incognitas,Abiertas,Cuerpo,Depth,Alpha,Beta,Player,ValorH,Fcont),!.

% alphaBeta([_|[Children]],Depth,Alpha,Beta,1,ValorH):-
%     Value is -5000,
%     forEachAlpha(Children,Value,Depth,Alpha,Beta,ValorH),!.

% alphaBeta([_|Children],Depth,Alpha,Beta,0,ValorH):-
%     Value is 5000,
%     forEachBeta(Children,Value,Depth,Alpha,Beta,ValorH).


forEachAlpha(_,_,_,_,_,Alpha,Beta,_,_,_):-
    Alpha >= Beta,fail.

forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|[]],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
     childrenMax(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRet,Fcont),
     Camino = Child1,!.


forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
    childrenMax(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRes,Fcont),
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Childrens,Value,Depth,ValueRes,Beta,ValueRet,Fcont,Camino),!.


forEachBeta(_,_,_,_,_,Alpha,Beta,_,_,_):-
    Alpha >= Beta,fail.

forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|[]],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
     childrenMin(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRet,Fcont),
     Camino = Child1,!.

forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
    childrenMin(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRes,Fcont),
    forEachBeta(MisPiezas,Incognitas,Abiertas,Childrens,Value,Depth,Alpha,ValueRes,ValueRet,Fcont,Camino),!.

maxim([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1>=Valor2,
    Res = [Pieza|Valor1],!.


%maxim([Pieza|Valor1],[_|Valor2],Res):-
%    Valor1>=Valor2,
 %   Res = [Pieza|Valor1],!.

%maxim([Pieza|Valor1],Valor2,Res):-
 %   Valor1>=Valor2,
  %  Res = [Pieza|Valor1],!.

maxim(_,Valor2,Res):-
    Res = Valor2.

childrenMax(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValueRet,Fcont):-
    Abiertas = [A1,A2],
    Children = [[Num1,Num2]|_],
    ((A1 =:= Num1 ->
        Nabiertas = [Num2,A2]);

    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    (Nabiertas = [A1,Num2])),

    DepthN is Depth -1,
    %Value = [_|NAlpha],

    (DepthN=\=0 ->
    alphaBeta(MisPiezas,Incognitas,Nabiertas,[],DepthN,Value,Beta,0,ValorH,Fcont),
    maxim(Value,ValorH,ValueRes),
    maxim(Alpha,ValueRes,AlphaN),
    ValueRet = AlphaN,!);

    DepthN is Depth -1,
    (DepthN=:=0 ->
     Abiertas = [A1,A2],
    Children = [[Num1,Num2]|_],
    ((A1 =:= Num1 ->
        Nabiertas = [Num2,A2]);

    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    (Nabiertas = [A1,Num2])),

   % NPeso is Peso +2,
    %NChildren = [[Num1,Num2]|NPeso],
    alphaBeta(MisPiezas,Incognitas,Nabiertas,Children,DepthN,Value,Beta,0,ValorH,Fcont),

    maxim(Value,ValorH,ValueRes),
    maxim(Alpha,ValueRes,AlphaN),
    ValueRet = AlphaN,!).

minmin([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1=<Valor2,
    Res = [Pieza|Valor1],!.

%minmin([Pieza|Valor1],Valor2,Res):-
 %   Valor1=<Valor2,
  %  Res = [Pieza|Valor1],!.

minmin(_,Valor2,Res):-
    Res = Valor2.

childrenMin(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValueRet,Fcont):-
    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    ((A1 =:= Num1 ->
        Nabiertas = [Num2,A2]);

    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    (Nabiertas = [A1,Num2])),

    DepthN is Depth -1,
    Nfcont is Fcont - 1,

    (DepthN=\=0 ->  alphaBeta(MisPiezas,Incognitas,Nabiertas,[],DepthN,Alpha,Value,1,ValorH,Nfcont),
    minmin(Value,ValorH,ValueRes),
    minmin(Beta,ValueRes,BetaN),
    ValueRet = BetaN,!);

    DepthN is Depth -1,
    (DepthN=:=0 ->
    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    ((A1 =:= Num1 ->
        Nabiertas = [Num2,A2]);

    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
    (Nabiertas = [A1,Num2])),


    Nfcont is Fcont - 1,
    %NPeso is Peso +2,
    %NChildren = [[Num1,Num2]|NPeso],
    alphaBeta(MisPiezas,Incognitas,Nabiertas,Children,DepthN,Alpha,Value,1,ValorH,Nfcont),

    minmin(Value,ValorH,ValueRes),
    minmin(Beta,ValueRes,BetaN),
    ValueRet = BetaN,!).
%
conHujos([]):-
   write("Sin fichas disponibles").
conHujos(_).
%
generaArbol(Fichas,[X|[Y]],Hijos):-
    (X =\= Y ->
    buscaHijo(Fichas,X,[],HijosX),
    buscaHijo(Fichas,Y,[],HijosY),
    append(HijosX,HijosY,Hijos),conHujos(Hijos),!);
   (X==Y -> buscaHijo(Fichas,X,[],HijosX),
    append(HijosX,[],Hijos),conHujos(Hijos),!).

buscaHijo([],_,Parcial,Hijos):-
    Hijos = Parcial.

buscaHijo([Cabeza|Cola],X,Parcial,Hijos):-
    Cabeza = [NumFicha|_],
    (member(X,NumFicha) ->
        (NumFicha = [Num1|[Num2]],
        (Num1=:=Num2 -> cambiarHijos([[Num1|[Num2]]|_],X,Res)),
        append(Parcial,[Res],P2),
        buscaHijo(Cola,X,P2,Hijos);

        NumFicha = [Num1|[Num2]],
        cambiarHijos([[Num1|[Num2]]|_],X,Res),
        append(Parcial,[Res],P2),
        buscaHijo(Cola,X,P2,Hijos)));

    buscaHijo(Cola,X,Parcial,Hijos),!.


cambiarHijos([[Num1|[Num2]]|_],X,Res):-
    Num1 =:= X,
    Res = [[Num1|[Num2]],_],!.

cambiarHijos([[Num1|[Num2]]|_],_,Res):-
    Res = [[Num2|[Num1]],_].




