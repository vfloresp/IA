%Domino: Las chicas superpoderosas y Víctor.
%Gabriela Cholico Santoyo
%Víctor Hugo Flores Pineda
%Rebeca Baños García


% consulta:
% alphaBeta([MisFichas],[[[6,6],A],[[5,6],B],[[4,6],C],[[3,6],D],[[2,6],E],[[1,6],F],[[0,6],G],[[5,5],H],[[4,5],I],[[3,5],J],[[2,5],K],[[1,5],L],[[0,5],M],[[4,4],N],[[3,4],O],[[2,4],P],[[1,4],Q],[[0,4],R],[[3,3],S],[[2,3],T],[[1,3],U],[[0,3],V],[[2,2],W],[[1,2],Y],[[0,2],Z],[[1,1],XX],[[0,1],YY],[[0,0],ZZ]],[6,6],[],3,[[],-5000],[[],5000],1,ValorH,7).


% Predicado al que entra el método de alphaBeta cuando la lista de
% fichas a elegir la mejor ficha para tirar posible es vacía, es decir,
% ya no hay fichas que elegir
% En este método se asignan los pesos de cada ficha, en
% nuestro caso fue sumar ambos números de la ficha de domminó y darle un
% peso mayor si es mula.
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

% Predicado al que entra el método alphaBeta cuando la profundidad del
% árbol a analizar es cero, es decir, nos encontramos en un nodo hoja.
% En este método igulmente se asignan los pesos de cada ficha, en
% nuestro caso fue sumar ambos números de la ficha de domminó y darle un
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


% Predicado al que entra primero el código cuando estamos en jugador 1.
% Los parametros necesarios son las fichas en nuestra mano, todas las
% que no conocemos, los puntos abiertos del juego, la profundidad a la
% que haremos alphaBeta, nuestros valores de alpha y beta, el valor de
% la ficha que queremos que nos regrese y la cantidad de fichas que
% tiene el contrincante
% La idea de este predicado es llamar a que se genere el próximo nivel
% del árbol con base en las piezas que tenemos y podemos usar como
% jugadas para eventualmente tener el árbol de tamaño Depth
alphaBeta(MisPiezas,Incognitas,Abiertas, [],Depth,Alpha,Beta,1,ValorH,Fcont):-
    generaArbol(MisPiezas,Abiertas,Hijos),
    append([Abiertas],Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,1,ValorH,Fcont).


% Predicado al que entra el código cuando analiza la mejor opción que
% debería jugar el contrincante. Los parametros necesarios son las
% fichas en nuestra mano, todas las que no conocemos, los puntos
% abiertos del juego, la profundidad a la que haremos alphaBeta,
% nuestros valores de alpha y beta, el valor de la ficha que queremos
% que nos regrese y la cantidad de fichas que tiene el contrincante.
alphaBeta(MisPiezas,Incognitas,Abiertas, [],Depth,Alpha,Beta,0,ValorH,Fcont):-
    generaArbol(Incognitas,Abiertas,Hijos),
    append([Abiertas],Hijos,Arbol),
    alphaBeta(MisPiezas,Incognitas,Abiertas, Arbol,Depth,Alpha,Beta,0,ValorH,Fcont).


% Manda a llamar al forEach de Alpha con el árbol generado con las
% piezas posibles de poner en el tiro correspondiente, es decir, las
% que coinciden en los puntos abiertos. Al final, el resultado del
% forEach lo agrega a una lista para regresar todas las piezas elegidas
% del camino hasta la profundidad dada.
alphaBeta(MisPiezas,Incognitas,Abiertas, [_|Children],Depth,Alpha,Beta,1,NValorH,Fcont):-
    Value = Alpha,
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValorH,Fcont,Camino),
    append([ValorH],Camino,NValorH),!.


% Manda a llamar al forEach de Beta con el árbol generado con las piezas
% posibles de poner en el tiro correspondiente, es decir, las que
% coinciden en los puntos abiertos. Al final, el resultado del forEach
% lo agrega a una lista para regresar todas las piezas elegidas del
% camino hasta la profundidad dada.
alphaBeta(MisPiezas,Incognitas,Abiertas,[_|Children],Depth,Alpha,Beta,0,NValorH,Fcont):-
    Value = Beta,
    forEachBeta(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValorH,Fcont,Camino),
    append([ValorH],Camino, NValorH),!.

%Poda la rama sobrante del árbol (creo que tampoco lo usamos Gabs)
forEachAlpha(_,_,_,_,_,Alpha,Beta,_,_,_):-
    Alpha >= Beta,fail.

% Último forEach realizado para la búsqueda, entra a este método cuando
% solo queda un nodo por explorar y por eso solo llama una vez a
% childrenMax
forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|[]],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
     childrenMax(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRet,Fcont),
     Camino = Child1,!.

% El forEach de Alpha manda a llamar a childrenMax para empezar a
% maximizar. Le manda el árbol generado anteriormente con las posibles
% fichas que puede tirar, es decir, las que coinciden con los puntos
% abiertos del juego. Método recursivo que al final manda a llamarse de
% nuevo.
forEachAlpha(MisPiezas,Incognitas,Abiertas,[Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
    childrenMax(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRes,Fcont),
    forEachAlpha(MisPiezas,Incognitas,Abiertas,Childrens,Value,Depth,ValueRes,Beta,ValueRet,Fcont,Camino),!.


%Poda la rama sobrante del árbol
forEachBeta(_,_,_,_,_,Alpha,Beta,_,_,_):-
    Alpha >= Beta,fail.


% Último forEach de Beta realizado para la búsqueda, entra a este método
% cuando solo queda un nodo por explorar y por eso solo llama una vez a
% childrenMin
forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|[]],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
     childrenMin(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRet,Fcont),
     Camino = Child1,!.


% El forEach de Beta manda a llamar a childrenMin para empezar a
% minimizar. Le manda el árbol generado anteriormente con las posibles
% fichas que puede tirar, es decir, las que coinciden con los puntos
% abiertos del juego.
forEachBeta(MisPiezas,Incognitas,Abiertas,[Child1|Childrens],Value,Depth,Alpha,Beta,ValueRet,Fcont,Camino):-
    childrenMin(MisPiezas,Incognitas,Abiertas,Child1,Value,Depth,Alpha,Beta,ValueRes,Fcont),
    forEachBeta(MisPiezas,Incognitas,Abiertas,Childrens,Value,Depth,Alpha,ValueRes,ValueRet,Fcont,Camino),!.


%Predicado que elige el máximo entre dos valores dados como nodos.
maxim([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1>=Valor2,
    Res = [Pieza|Valor1],!.


%Predicado que asigna a Res el valor máximmo encontrado.
maxim(_,Valor2,Res):-
    Res = Valor2.


% Predicado que escoge el nodo con peso mayor para elegirlo como mejor
% ficha para tirar en el turno correspondiente. Además, cambia los
% puntos abiertos del juego para que al seguir buscando se actualicen
% las piezas disponibles para cada turno del juego. Este método detecta
% cuando la profundidad del árbol es 0, es decir, nos encontramos en un
% nodo hoja, por lo que empieza es escoger entre los valores de los
% nodos el de mayor peso para tirar en el turno.
childrenMax(MisPiezas,Incognitas,Abiertas,Children,Value,Depth,Alpha,Beta,ValueRet,Fcont):-
    Abiertas = [A1,A2],
    Children = [[Num1,Num2]|_],
    ((A1 =:= Num1 ->
        Nabiertas = [Num2,A2]);

    Children = [[Num1,Num2]|_],
    Abiertas = [A1,A2],
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
    ValueRet = AlphaN,!).


%Predicado que elige el mínimo entre dos valores dados como nodos.
minmin([Pieza|[Valor1]],[_|[Valor2]],Res):-
    Valor1=<Valor2,
    Res = [Pieza|Valor1],!.


%Predicado que asigna a Res el valor mínimo encontrado.
minmin(_,Valor2,Res):-
    Res = Valor2.


% Predicado que escoge el nodo con peso menor para elegirlo como mejor
% ficha para tirar del oponente en el turno correspondiente. Además,
% cambia los puntos abiertos del juego para que al seguir buscando se
% actualicen las piezas disponibles para cada turno del juego. Este
% método detecta cuando la profundidad del árbol es 0, es decir, nos
% encontramos en un nodo hoja, por lo que empieza es escoger entre los
% valores de los nodos el de menor peso para tirar en el turno.
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


% Determina si el árbol generado es vacío, si es así, significa que no
% tenemos fichas disponibles que tirar, por lo que se tiene que tomar
% una o pasar de turno.
conHijos([]):-
   write("Sin fichas disponibles").


% Predicado que determina si el árbol generado no es vacío, si es así,
% continua con el resto del método.
conHijos(_).


% Predicado que genera el árbol con las fichas que podemos tirar en el
% turno correspondiente de acuerdo a los puntos abiertos del juego.
generaArbol(Fichas,[X|[Y]],Hijos):-
    (X =\= Y ->
    buscaHijo(Fichas,X,[],HijosX),
    buscaHijo(Fichas,Y,[],HijosY),
    append(HijosX,HijosY,Hijos),conHijos(Hijos),!);
   (X==Y -> buscaHijo(Fichas,X,[],HijosX),
    append(HijosX,[],Hijos),conHijos(Hijos),!).


%Predicado que detiene la recursividad al tener la lista vacía.
buscaHijo([],_,Parcial,Hijos):-
    Hijos = Parcial.


% Predicado que busca las fichas suyos números coincidan con los puntos
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


% Predicado que acomoda los nodos con el número que se debe de usar en
% la jugada a la izquierda y nuevo valor de punto abierto a la derecha.
cambiarHijos([[Num1|[Num2]]|_],X,Res):-
    Num1 =:= X,
    Res = [[Num1|[Num2]],_],!.


% Predicado que acomoda los nodos con el número que se debe de usar en
% la jugada a la izquierda y nuevo valor de punto abierto a la derecha.
% Lo deja igual si ya está acomodado correctamente.
cambiarHijos([[Num1|[Num2]]|_],_,Res):-
    Res = [[Num2|[Num1]],_].




