/*Programa para que opere el método de búsqueda A*
Autores: Rebeca Baños (157655), Gabriela Cholico (152854), Victor Flores y Aldo
Fecha: 11 de Mayo 2019*/

/*input: final (canción a la que queremos llegar), lista que describe al grafo que tiene
información de canciones
output: lista lineal de resultados
nodo de canción: [id,valor heurístico, [id vecino 1, distancia entre nodo actual y vecino 1],..
...,[id vecino n, distancia entre nodo actual y vecino n]].*/
/*consulta: aEstrella('zy24',[['42ab',25,['32fa',4],['ds54',11]],['32fa',15,['48lo',3],['31cd',6]],['48lo',11,['zy24',1],['76de',2]],['31cd',10],['76de',5],['ds54',13,['22db',6],['cc66',5]],['22db',10],['cc66',9,['zy24',3]],['zy24',0]])*/

/* -------------------------Algoritmo de búsqueda A*----------------------------
Se le pide al usuario una lista que describa el grafo de la familia de canciones que
describa la trayectoria de una canción hacia otra descrita con otras canciones de por medio
y el id de la canción final que a la que se quiere llegar. El grafo debe de comenzar con
el nodo de la canción inicial a la búsqueda.*/

/*Busca entre todo el grafo el nodo al que le corresponde el id deseado para obtener su
valor heurístico*/
buscaValorHSucesor(IDSucesor,Todos,ValorH):-
	Todos = [Cabeza|_],
	Cabeza = [IDSucesorCabeza,ValorCabeza|_],
	IDSucesorCabeza == IDSucesor ,
	ValorH = ValorCabeza,!.

buscaValorHSucesor(IDSucesor,Todos,ValorH):-
	Todos = [_|Cuerpo],
	buscaValorHSucesor(IDSucesor,Cuerpo,ValorH).

/*Desde el nodo actual, se buscan los ids de los nodos vecinos para obtener sus
valores heurístico y las distancias entre ellos (nodo actual y nodo vecino) para
calcular la suma entre estos dos valores más la distancia que se ha recorrido previamente.
Este resultado (llamado valor f) es usado para comparar las canciones entre sí.*/
buscaSucesores([PrimerSucesor|[]],Todos, NSucesores,CostoCamino):-
	PrimerSucesor = [IDSucesor|[DistSucesor]],
	buscaValorHSucesor(IDSucesor,Todos,ValorH),
	CostoPrimerSucesor is DistSucesor+ValorH+CostoCamino,
	append(PrimerSucesor,[CostoPrimerSucesor],Conexion),
	NSucesores = [Conexion],!.

buscaSucesores(Sucesores,Todos, SucesoresFinal,CostoCamino):-
	Sucesores = [PrimerSucesor|RestoSucesores],
	PrimerSucesor = [IDSucesor|[DistSucesor]],
	buscaValorHSucesor(IDSucesor,Todos,ValorH),
	CostoPrimerSucesor is DistSucesor+ValorH+CostoCamino,
	append(PrimerSucesor,[CostoPrimerSucesor],Conexion),
	Nsus = [Conexion],
	buscaSucesores(RestoSucesores,Todos,NSucesores,CostoCamino),
	append(Nsus,NSucesores,SucesoresFinal).

/*Compara los valores f de dos vecinos del nodo y se entrega el nodo de que tiene menor valor f*/
minmin(PrimerSucesor,SegundoSucesor,Menor):-
	PrimerSucesor = [_,_|[F1]],
	SegundoSucesor = [_,_|[F2]],
	F1 =< F2,
	Menor = PrimerSucesor,!.

minmin(_,SegundoSucesor,Menor):-
	Menor = SegundoSucesor,!.


/*Usa el método anterior (minmin) para comparar los valores f de todos los vecinos del nodo
hasta encontrar el que tiene el menor valor f; una vez encontrado, se obtiene la  distancia
entre ese vecino y el nodo actual y se le suma a la distancia recorrida hasta el momento.*/
buscaMenor(SucesoresFinal,Menor,CostoCamino,TCosto):-
	SucesoresFinal = [Sucesor],
	Sucesor = [_,Gmenor|_],
	Menor = Sucesor,
	TCosto is CostoCamino + Gmenor.


buscaMenor(SucesoresFinal,MenorMenor,CostoCamino,TCosto):-
	SucesoresFinal = [PrimerSucesor,SegundoSucesor|RestoSucesores],
	minmin(PrimerSucesor,SegundoSucesor,Menor),
	append([Menor],RestoSucesores,OSucesores),
	buscaMenor(OSucesores,MenorMenor,CostoCamino,TCosto),!.

/*Busca el nodo que tiene el id del vecino con la distancia menor al nodo actual entre
todos los nodos que hay en el grafo */
revisarID(IDMenor,Todos,NodoMenor):-
	Todos = [PrimerNodo|_],
	PrimerNodo = [ID, _ |_],
	ID == IDMenor,
	NodoMenor = PrimerNodo,!.

revisarID(IDMenor,Todos,NodoMenor):-
	Todos = [_|CuerpoNodos],
        revisarID(IDMenor,CuerpoNodos,NodoMenor).

/*Verifica si ya se encontró el nodo que describe la canción a la que queremos llegar, si es así
para la búsqueda.*/
checaFinal(Final, NodoMenor):-
	NodoMenor = [ID,_],
	Final == ID,
	fail.

checaFinal(_,_):-
	!.

/*Inicia la búsqueda de A* con el primer nodo, encuentra el nodo vecino con la menor distancia,
imprime el id del nodo menor,
suma esta distancia a la distancia recorrida y toma este nodo vecino como el nuevo nodo
actual para seguir la búsqueda hasta que el nodo vecino con menor distancia sea el nodo
de la canción final.*/
cabezaOperaciones(Inicial,Resto,CostoCamino,Final):-
	Inicial = [_, _|Sucesores],
	buscaSucesores(Sucesores,Resto,SucesoresFinal,CostoCamino),
	buscaMenor(SucesoresFinal,MenorMenor,CostoCamino,TCosto),
	MenorMenor = [IDMenor|_],
	revisarID(IDMenor,Resto,NodoMenor),
	write(IDMenor),nl,
	checaFinal(Final,NodoMenor),
	cabezaOperaciones(NodoMenor,Resto,TCosto,Final).

/*Inicia la búsqueda de usando A* con el primer nodo del grafo (que representa la canción de la que queremos partir)*/
aEstrella(Final,Todos):-
	Todos = [Inicial|Resto],
	CostoCamino is 0,
	cabezaOperaciones(Inicial,Resto,CostoCamino,Final).


