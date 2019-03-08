

%EjemploArbol is [[6,6],[[6,5],[6,4]]].%
%BaseDatos is [[6,6],[5,6],[4,6],[3,6],[2,6],[1,6],[0,6],[5,5],[4,5],[3,5],[2,5],[1,5],[0,5],[4,4],[3,4],[2,4],[1,4],[0,4],[3,3],[2,3],[1,3],[0,3],[2,2],[1,2],[0,2],[1,1],[0,1],[0,0]].%
%Abierto is lista de 2.%
%Incognitas is lista de piezas que no sabemos.%
%MiJuego is  lista de fichas que yo tengo.%

% Arbol is arbol que vamos a estar generando en el momento - se va a%
% estar generan%do en cada turno.%


alphaBeta(node,depth,alpha,beta,player):-
    depth==0,
    nodeValue,!.

alphaBeta(node,depth,alpha,beta,player):-
    node==terminal-sin-hijos,
    nodeValue,!.

alphaBeta([head|children],depth,alpha,beta,player):-
    player==1,
    value is -5000,
    forEachAlpha(children,value,depth,alpha,beta,valueRet),write(valueRet).

forEachAlpha([child1|[]],value,depth,alpha,beta,valueRet):-
     childrenMax(child1,value,depth,alpha,beta,valueRet).

forEachAlpha([child1|childrens],value,depth,alpha,beta,valueRet):-
    childrenMax(child1,value,depth,alpha,beta,valueRet),
    childrenMax(childrens,value,depth,alpha,beta,valueRet),!.

childrenMax(children,value,depth,alpha,beta,valueRet):-
    depthN is depth -1,
    playerN is 0,
    maxim(value,alphaBeta(children,depthN,alpha,beta,playerN),valueRet),
    maxim(alpha,valueRet,alphaN),
    compara(alphaN,beta),!.

compara(alpha,beta):-
    alpha >= beta,fail.

maxim(valor1,valor2,res):-
    valor1>valor2,
    res = valor1,!.

maxim(valor1,valor2,res):-
    res = valor2.


alphaBeta(node,depth,alpha,beta,player):-
    player==0,
    value is 5000,
    forEachBeta(children,value,depth,alpha,beta,valueRet),write(valueRet).


forEachAlpha([child1|[]],value,depth,alpha,beta,valueRet):-
     childrenMin(child1,value,depth,alpha,beta,valueRet).

forEachAlpha([child1|childrens],value,depth,alpha,beta,valueRet):-
    childrenMin(child1,value,depth,alpha,beta,valueRet),
    childrenMin(childrens,value,depth,alpha,beta,valueRet),!.

childrenMin(children,value,depth,alpha,beta,valueRet):-
    depthN is depth -1,
    playerN is 1,
    minmin(value,alphaBeta(children,depthN,alpha,beta,playerN),valueRet),
    minmin(alpha,valueRet,alphaN),
    compara(alphaN,beta),!.

minmin(valor1,valor2,res):-
    valor1<valor2,
    res = valor1,!.

minmin(valor1,valor2,res):-
    res = valor2.



