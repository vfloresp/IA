%Domino: Las chicas superpoderosas y V�ctor.
%Gabriela Cholico Santoyo
%V�ctor Hugo Flores Pineda
%Rebeca Ba�os Garc�a


% consulta:
% alphaBeta([MisFichas],[[[6,6],A],[[5,6],B],[[4,6],C],[[3,6],D],[[2,6],E],[[1,6],F],[[0,6],G],[[5,5],H],[[4,5],I],[[3,5],J],[[2,5],K],[[1,5],L],[[0,5],M],[[4,4],N],[[3,4],O],[[2,4],P],[[1,4],Q],[[0,4],R],[[3,3],S],[[2,3],T],[[1,3],U],[[0,3],V],[[2,2],W],[[1,2],Y],[[0,2],Z],[[1,1],XX],[[0,1],YY],[[0,0],ZZ]],[6,6],[],3,[[],-5000],[[],5000],1,ValorH,7).


% Predicado al que entra el m�todo de alphaBeta cuando la lista de
% fichas a elegir la mejor ficha para tirar posible es vac�a, es decir,
% ya no hay fichas que elegir
% En este m�todo se asignan los pesos de cada ficha, en
% nuestro caso fue sumar ambos n�meros de la ficha de dommin� y darle un
% peso mayor si es mula.
/* alphaBeta([],_,_,Nodo,_,_,_,_,ValorH,_):-
    Nodo = [[Num1,Num2]|_],
    (Num1=:=Num2 ->
    Peso is Num1+Num2+13,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!);

    Nodo = [[Num1,Num2]|_],
    (Num1=\=Num2 -> Peso is Num1+Num2,
    Nnodo = [[Num1, Num2],Peso],
    ValorH = Nnodo,!). */

% Predicado al que entra el m�todo alphaBeta cuando la profundidad del
% �rbol a analizar es cero, es decir, nos encontramos en un nodo hoja.
% En este m�todo igulmente se asignan los pesos de cada ficha, en
% nuestro caso fue sumar ambos n�meros de la ficha de dommin� y darle un
% peso mayor si es mula.
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


alphaBeta([],_,_,[Head|[]],Depth,_,_,_,ValorH,_):-
    ValorEuristico is 500*Depth,
    ValorH = [Head,ValorEuristico],!.

alphaBeta(_,_,_,[Head|[]],Depth,_,_,_,ValorH,0):-
    ValorEuristico is -500*Depth,
    ValorH = [Head,ValorEuristico],!.


alphaBeta(MisPiezas,Incognitas,Abiertas, [Head|[]],Depth,Alpha,Beta,1,ValorH,Fcont):-
    generaArbol(MisPiezas,Abiertas,Hijos),
    (Hijos == [] ->
        ValorEuristico is -150*Depth,
        ValorH = [Head,ValorEuristico],!);
    generaArbol(Incognitas,Abiertas,Hijos),
    append(Head,Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,1,ValorH,Fcont).

% Predicado al que entra primero el c�digo cuando estamos en jugador 1.
% Los parametros necesarios son las fichas en nuestra mano, todas las
% que no conocemos, los puntos abiertos del juego, la profundidad a la
% que haremos alphaBeta, nuestros valores de alpha y beta, el valor de
% la ficha que queremos que nos regrese y la cantidad de fichas que
% tiene el contrincante
% La idea de este predicado es llamar a que se genere el pr�ximo nivel
% del �rbol con base en las piezas que tenemos y podemos usar como
% jugadas para eventualmente tener el �rbol de tama�o Depth
alphaBeta(MisPiezas,Incognitas,Abiertas, [],Depth,Alpha,Beta,1,ValorH,Fcont):-
    generaArbol(Incognitas,Abiertas,Hijos),
    append([Abiertas],Hijos,Arbol),
    nb_setval(alpha,Alpha),
    nb_setval(beta,Beta),
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Arbol,Depth,Alpha,Beta,ValorH,Fcont,-5000).


% Predicado al que entra el c�digo cuando analiza la mejor opci�n que
% deber�a jugar el contrincante. Los parametros necesarios son las
% fichas en nuestra mano, todas las que no conocemos, los puntos
% abiertos del juego, la profundidad a la que haremos alphaBeta,
% nuestros valores de alpha y beta, el valor de la ficha que queremos
% que nos regrese y la cantidad de fichas que tiene el contrincante.
alphaBeta(MisPiezas,Incognitas,Abiertas, [Head|[]],Depth,Alpha,Beta,0,ValorH,Fcont):-
    generaArbol(Incognitas,Abiertas,Hijos),
    (Hijos == [] ->
        ValorEuristico is 150*Depth,
        ValorH = [Head,ValorEuristico],!);
    generaArbol(Incognitas,Abiertas,Hijos),
    append(Head,Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,0,ValorH,Fcont).


%Poda la rama sobrante del �rbol (creo que tampoco lo usamos Gabs)
%forEachAlpha(_,_,_,_,_,Alpha,Beta,_,_,_):-
%    Alpha >= Beta,fail.

% �ltimo forEach realizado para la b�squeda, entra a este m�todo cuando
% solo queda un nodo por explorar y por eso solo llama una vez a
% childrenMax
forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|[]],Depth,Alpha,NAlpha,ValorH,Fcont,ValueRet):-
    eliminaPieza(MisPiezas,Child1,MisPiezasN),
    nuevaAbiertas(Abiertas,Child1,AbiertasN),
    Ndepth is Depth-1,
    alphaBeta(MisPiezasN,Incognitas,AbiertasN,[Child1|[]],Ndepth,Alpha,NAlpha,0,ValorAlphaBeta,Fcont),
    max([Child1,ValueRet],ValorAlphaBeta,ValorH),
    max([Child1,Alpha],ValorH,NAlpha),!.

% El forEach de Alpha manda a llamar a childrenMax para empezar a
% maximizar. Le manda el �rbol generado anteriormente con las posibles
% fichas que puede tirar, es decir, las que coinciden con los puntos
% abiertos del juego. M�todo recursivo que al final manda a llamarse de
% nuevo.
forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|Children],Depth,Alpha,Beta,ValorH,Fcont,ValueRet):-
    eliminaPieza(MisPiezas,Child1,MisPiezasN),
    nuevaAbiertas(Abiertas,Child1,AbiertasN),
    Ndepth is Depth-1,
    alphaBeta(MisPiezasN,Incognitas,AbiertasN,[Child1|[]],Ndepth,-5000,5000,0,ValorAlphaBeta,Fcont),
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Children,Depth,Alpha,Beta,ValorH,Fcont,ValueRet2),
    max([Child1,ValueRet2],ValorAlphaBeta,ValorH),
    max([Child1,Alpha],ValorH,ValueRet),!.



% �ltimo forEach de Beta realizado para la b�squeda, entra a este m�todo
% cuando solo queda un nodo por explorar y por eso solo llama una vez a
% childrenMin
forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|[]],Depth,NBeta,Beta,ValorH,Fcont,ValueRet):-
    eliminaPieza(Incognitas,Child1,NIncognitas),
    nuevaAbiertas(Abiertas,Child1,AbiertasN),
    Ndepth is Depth-1,
    Nfcont is Fcont-1,
    alphaBeta(MisPiezas,NIncognitas,AbiertasN,[Child1|[]],Ndepth,_,_,1,ValorAlphaBeta,Nfcont),
    min(ValorH,ValorAlphaBeta,ValueRet),
    min([Child1,Beta],ValueRet,NBeta),!.


% El forEach de Beta manda a llamar a childrenMin para empezar a
% minimizar. Le manda el �rbol generado anteriormente con las posibles
% fichas que puede tirar, es decir, las que coinciden con los puntos
% abiertos del juego.
forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|Children],Depth,NBeta,Beta,ValorH,Fcont,ValueRet):-
    forEachBeta(MisPiezas,Incognitas,Abiertas,Children,Depth,BetaTemp,Beta,ValorH,Fcont,NValueRet),
    eliminaPieza(Incognitas,Child1,Nincognitas),
    nuevaAbiertas(Abiertas,Child1,AbiertasN),
    Ndepth is Depth-1,
    Nfcont is Fcont-1,
    alphaBeta(MisPiezas,Nincognitas,AbiertasN,[Child1|[]],Ndepth,BetaTemp,NBeta,1,ValorAlphaBeta,Nfcont),
    min(NValueRet,ValorAlphaBeta,ValueRet),
    min([Child1,BetaTemp],ValueRet,NBeta),!.

%Poda la rama sobrante del �rbol
%forEachBeta(_,_,_,_,_,Alpha,Beta,_,_,_):-
%    Alpha >= Beta,fail.


eliminaPieza([[[X,Y],Var]|ColaIni],[[ElimX,ElimY]|_],Resultado):-
    (X=:=ElimX->
        (Y=:=ElimY->
            Resultado = ColaIni,!)
        );
    eliminaPieza(ColaIni,[[ElimX,ElimY]|_],ColaRes),
    Resultado = [[[X,Y],Var]|ColaRes].

nuevaAbiertas([X,Y],[[Z,W]|_],Resultado):-
    (X=:=Z->
        Resultado=[Y,W],!);
    (Y=:=Z->
        Resultado=[X,W],!);
    (X=:=W->
        Resultado=[Y,Z],!);
    (Y=:=W->
        Resultado=[X,Z],!).


%Predicado que elige el m�ximo entre dos valores dados como nodos.
max([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1>=Valor2,
    Res = [Pieza|Valor1],!.


%Predicado que asigna a Res el valor m�ximmo encontrado.
max(_,Valor2,Res):-
    Res = Valor2.


%Predicado que elige el m�nimo entre dos valores dados como nodos.
min([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1=<Valor2,
    Res = [Pieza|Valor1],!.


%Predicado que asigna a Res el valor m�nimo encontrado.
min(_,Valor2,Res):-
    Res = Valor2.

% Predicado que genera el �rbol con las fichas que podemos tirar en el
% turno correspondiente de acuerdo a los puntos abiertos del juego.
generaArbol(Fichas,[X|[Y]],Hijos):-
    (X =\= Y ->
    buscaHijo(Fichas,X,[],HijosX),
    buscaHijo(Fichas,Y,[],HijosY),
    append(HijosX,HijosY,Hijos),!);
   (X==Y -> buscaHijo(Fichas,X,[],HijosX),
    append(HijosX,[],Hijos),!).


%Predicado que detiene la recursividad al tener la lista vac�a.
buscaHijo([],_,Parcial,Hijos):-
    Hijos = Parcial.


% Predicado que busca las fichas suyos n�meros coincidan con los puntos
% abiertos del juego en el turno correspondiente.
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


% Predicado que acomoda los nodos con el n�mero que se debe de usar en
% la jugada a la izquierda y nuevo valor de punto abierto a la derecha.
cambiarHijos([[Num1|[Num2]]|_],X,Res):-
    Num1 =:= X,
    Res = [[Num1|[Num2]],_],!.


% Predicado que acomoda los nodos con el n�mero que se debe de usar en
% la jugada a la izquierda y nuevo valor de punto abierto a la derecha.
% Lo deja igual si ya est� acomodado correctamente.
cambiarHijos([[Num1|[Num2]]|_],_,Res):-
    Res = [[Num2|[Num1]],_].







% Manda a llamar al forEach de Alpha con el �rbol generado con las
% piezas posibles de poner en el tiro correspondiente, es decir, las
% que coinciden en los puntos abiertos. Al final, el resultado del
% forEach lo agrega a una lista para regresar todas las piezas elegidas
% del camino hasta la profundidad dada.
%alphaBeta(MisPiezas,Incognitas,Abiertas, [_|Children],Depth,Alpha,Beta,1,ValorH,Fcont):-
%    generaArbol(MisPiezas,Abiertas,Hijos),
 %   forEachAlpha(MisPiezas,Incognitas,Abiertas,Children,Depth,Alpha,Beta,ValorH,Fcont,ValueRet),!.


% Manda a llamar al forEach de Beta con el �rbol generado con las piezas
% posibles de poner en el tiro correspondiente, es decir, las que
% coinciden en los puntos abiertos. Al final, el resultado del forEach
% lo agrega a una lista para regresar todas las piezas elegidas del
% camino hasta la profundidad dada.
%alphaBeta(MisPiezas,Incognitas,Abiertas,[_|Children],Depth,Alpha,Beta,0,NValorH,Fcont):-
%    Value = Beta,
%    forEachBeta(MisPiezas,Incognitas,Abiertas,Children,Depth,Alpha,Beta,ValorH,Fcont,ValueRet),
%    append([ValorH],Camino, NValorH),!.



% Predicado que escoge el nodo con peso mayor para elegirlo como mejor
% ficha para tirar en el turno correspondiente. Adem�s, cambia los
% puntos abiertos del juego para que al seguir buscando se actualicen
% las piezas disponibles para cada turno del juego. Este m�todo detecta
% cuando la profundidad del �rbol es 0, es decir, nos encontramos en un
% nodo hoja, por lo que empieza es escoger entre los valores de los
% nodos el de mayor peso para tirar en el turno.
%childrenMax(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValueRet,Fcont):-
%    Abiertas = [A1,A2],
%    Children = [[Num1,Num2]|_],
%    ((A1 =:= Num1 ->
%        Nabiertas = [Num2,A2]);

%    Children = [[Num1,Num2]|_],
   /*  Abiertas = [A1,A2],
    (Nabiertas = [A1,Num2])),

    DepthN is Depth -1,

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

     alphaBeta(MisPiezas,Incognitas,Nabiertas,Children,DepthN,Value,Beta,0,ValorH,Fcont),

    maxim(Value,ValorH,ValueRes),
    maxim(Alpha,ValueRes,AlphaN),
    ValueRet = AlphaN,!). */




% Predicado que escoge el nodo con peso menor para elegirlo como mejor
% ficha para tirar del oponente en el turno correspondiente. Adem�s,
% cambia los puntos abiertos del juego para que al seguir buscando se
% actualicen las piezas disponibles para cada turno del juego. Este
% m�todo detecta cuando la profundidad del �rbol es 0, es decir, nos
% encontramos en un nodo hoja, por lo que empieza es escoger entre los
/* % valores de los nodos el de menor peso para tirar en el turno.
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
    alphaBeta(MisPiezas,Incognitas,Nabiertas,Children,DepthN,Alpha,Value,1,ValorH,Nfcont),

    minmin(Value,ValorH,ValueRes),
    minmin(Beta,ValueRes,BetaN),
    ValueRet = BetaN,!).
 */

% Determina si el �rbol generado es vac�o, si es as�, significa que no
% tenemos fichas disponibles que tirar, por lo que se tiene que tomar
% una o pasar de turno.
%conHijos([]):-
%   write("Sin fichas disponibles").


% Predicado que determina si el �rbol generado no es vac�o, si es as�,
% continua con el resto del m�todo.
%conHijos(_).







