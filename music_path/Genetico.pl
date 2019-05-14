/*Programa de un algoritmo genético basado en mutación
Autores: Rebeca Baños (157655), Gabriela Cholico (152854), Victor Flores y Aldo 
Fecha: 11 de Mayo 2019*/

/*nodo = genes ; genes = [danceability, energy, acousticness, instrumentalness, balance]
input : cancion inicial (primer nodo) y final (condicion de paro)
output: familia de genes - max (200), min (1)
CONSULTA: algGenerico([0.53,0.21,0.11,0.68,0.04],[0.45,0.12,0.11,0.53,0.1])*/

/*Verifica que el valor aleatorio asignado sea un 1 para que 
no modifique el gen de Valence*/
checarBal(Rand5, Valence, NBal,_):-
	Rand5 < 0.5,
	NBal is Valence,!.

/*Verifica que el valor aleatorio asignado sea un 1 para que 
sí modifique el gen de Valence*/
checarBal(Rand5, Valence, NBal,Signo):-
	Rand5 >= 0.5,
	(Signo =:= -1 -> NBal is Valence- 0.03;
					 NBal is Valence+ 0.03).

/*Verifica que el valor aleatorio asignado sea un 1 para que 
no modifique el gen de Instrumentalness */
checarInt(Rand4, Instrumentalness, NInst,_):-
	Rand4 < 0.5,
	NInst is Instrumentalness,!.

/*Verifica que el valor aleatorio asignado sea un 1 para que 
sí modifique el gen de Instrumentalness*/
checarInt(Rand4, Instrumentalness, NInst, Signo):-
	Rand4 >= 0.5,
	(Signo =:= -1 -> NInst is Instrumentalness - 0.1;
					 NInst is Instrumentalness + 0.1).

/*Verifica que el valor aleatorio asignado sea un 1 para que 
no modifique el gen de Acousticness*/
checarAc(Rand3, Acousticness, NAcou,_):-
	Rand3 < 0.5,
	NAcou is Acousticness, !.

/*Verifica que el valor aleatorio asignado sea un 1 para que 
sí modifique el gen de Acousticness*/
checarAc(Rand3, Acousticness, NAcou,Signo):-
	Rand3 >= 0.5,
	(Signo =:= -1 -> NAcou is Acousticness - 0.05;
					 NAcou is Acousticness + 0.05).

/*Verifica que el valor aleatorio asignado sea un 1 para que 
no modifique el gen de Energy*/
checarEn(Rand2,Energy, NEn,_):-
	Rand2 < 0.5,
	NEn is Energy, !.

/*Verifica que el valor aleatorio asignado sea un 1 para que 
sí modifique el gen de Energy*/
checarEn(Rand2,Energy, NEn, Signo):-
	Rand2 >= 0.5,
	(Signo =:= -1 -> NEn is Energy - 0.03;
					 NEn is Energy + 0.03).

/*Verifica que el valor aleatorio asignado sea un 0 para que 
no modifique el gen de Danceability*/
checarDance(Rand1,Danceability, NDanc,_):-
	Rand1 < 0.5,
	NDanc is Danceability, !.
/*Verifica que el valor aleatorio asignado sea un 1 para que 
sí modifique el gen de Danceability*/
checarDance(Rand1,Danceability, NDanc,Signo):-
	Rand1 >= 0.5,
	(Signo =:= -1 -> NDanc is Danceability - 0.03;
					 NDanc is Danceability + 0.03).

/*Compara el gen de Danceability de la canción actual con la 
canción final. Verifica que esté en el rango para ser modificada*/
comparaDance(Danceability,FDanceability,EsD,NDanc):-
	Error is FDanceability - Danceability,
	abs(Error) > 0.25,
	EsD = false,
	random(0,2,Rand),
	checarDance(Rand, Danceability, NDanc,sign(Error)),!.

/*Compara el gen de Danceability de la canción actual con la canción
final. Si está dentro del rango, ya no modifica ese gen*/
comparaDance(Danceability,_,EsD,NDanc):-
	NDanc is Danceability,
	EsD = true.

/*Compara el gen de Energy de la canción actual con la canción final. 
Verifica que esté en el rango para ser modificada*/
comparaEnergy(Energy,FEnergy,EsE,NEn):-
	Error is FEnergy - Energy,
	abs(Error) > 0.025,
	EsE = false,
	random(0,2,Rand),
	checarEn(Rand, Energy, NEn,sign(Error)),!.

/*Compara el gen de Energy de la canción actual con la canción final. 
Si está dentro del rango, ya no modifica ese gen*/
comparaEnergy(Energy,_,EsE,NEn):-
	NEn is Energy,
	EsE = true.

/*Compara el gen de Acousticness de la canción actual con la canción 
final. Verifica que esté en el rango para ser modificada*/
comparaAC(Acousticness,FAcousticness,EsAC,NAcou):-
	Error is FAcousticness - Acousticness,
	abs(Error) > 0.05 ,
	EsAC = false,
	random(0,2,Rand),
	checarAc(Rand, Acousticness, NAcou,sign(Error)),!.

/*Compara el gen de Acousticness de la canción actual con la canción 
final. Si está dentro del rango, ya no modifica ese gen*/
comparaAC(Acousticness,_,EsAC,NAcou):-
	NAcou = Acousticness,
	EsAC = true.

/*Compara el gen de Instrumentalness de la canción actual con la canción 
final. Verifica que esté en el rango para ser modificada*/
comparaInt(Instrumentalness,FInstrumentalness,EsIn,NInst):-
	Error is FInstrumentalness - Instrumentalness,
	abs(Error) > 0.075, EsIn = false,
	random(0,2,Rand),
	checarInt(Rand, Instrumentalness, NInst,sign(Error)),!.

/*Compara el gen de Instrumentalness de la canción actual con la canción 
final. Si está dentro del rango, ya no modifica ese gen*/
comparaInt(Instrumentalness,_,EsIn,NInst):-
	NInst = Instrumentalness,
	EsIn = true.

/*Compara el gen de Valence de la canción actual con la canción final. 
Verifica que esté en el rango para ser modificada*/
comparaBal(Valence,FValence,EsBal,NBal):-
	Error is FValence- Valence,
	abs(Error) > 0.025,
	EsBal = false,
	random(0,2,Rand),
	checarBal(Rand, Valence, NBal,sign(Error)),!.

/*Compara el gen de Valence de la canción actual con la canción final. 
Si está dentro del rango, ya no modifica ese gen*/
comparaBal(Valence,_,EsBal,NBal):-
	NBal = Valence,
	EsBal = true.

/*Predicado que verifica si cada uno de los genes ya está dentro del 
rango de la canción final*/
sonTrue(true,true,true,true,true,Valor):-
	Valor = true.

/*Predicado que continúa ejecutando el algoritmo ya que verificó si no 
todos los genes de cada canción están dentro del rango de la canción final*/
sonTrue(_,_,_,_,_,Valor):-
	Valor = false,!.

/*Predicado que compara cada uno de los genes de la canción y verifica si ya 
se encuentran dentro del rango del gen final para realizar un cambio dependiendo 
sea el caso o no*/
compara(CabezaP,Final,NuevoGen,Valor):-
	CabezaP = [Danceability,Energy|[Acousticness, Instrumentalness| [Valence]]],
	Final = [FDanceability,FEnergy|[FAcousticness, FInstrumentalness| [FValence]]],
	comparaDance(Danceability,FDanceability,EsD,NDanc),
	comparaEnergy(Energy,FEnergy,EsE,NEn),
	comparaAC(Acousticness,FAcousticness,EsAC,NAcou),
	comparaInt(Instrumentalness,FInstrumentalness,EsIn,NInst),
	comparaBal(Valence,FValence,EsBal,NBal),
	sonTrue(EsD,EsE,EsAC,EsIn,EsBal,Valor),
	NuevoGen = [NDanc,NEn,NAcou,NInst,NBal],
	!.
/*Predicado que detiene el algoritmo cuando se llega a que la combinación de datos
 numéricos está dentro de un rango en el que se parezca a los datos de la canción 
 final. Mientras los datos no estén en rango, no se va a detener*/
brk(true,NPoblacion,Final):-
	append([Final],NPoblacion,PF),
	write(PF),
	fail.

/*Predicado que continúa ejecutando el algoritmo ya que verificó que el rango de 
datos numéricos actuales no pertenecen al rango dentro de los datos de la canción final*/
brk(false,_,_):-
!.

/*Predicado de generaPoblacion. Le entran como parámetros la lista de los datos
 de la canción inicial y de la canción final, también le entra una lista vacía 
 para que ahí se vaya guardando los datos que va encontrando parecidos a los datos
  de la inicial y así acercarse a los datos de la canción final. Dentro de este 
  predicado utilizamos otros predicados para que el algoritmo funcione bien*/
generarPoblacion(Inicial,Poblacion,Final):-
	(Inicial == [] -> (Poblacion = [CabezaP|_],
					compara(CabezaP,Final,NuevoGen,Valor),
					brk(Valor,Poblacion,Final),
					(member(NuevoGen,Poblacion) -> (generarPoblacion([],Poblacion,Final));
													(generarPoblacion(NuevoGen,Poblacion,Final))));
					(append([Inicial],Poblacion,NPoblacion),
					compara(Inicial,Final,NuevoGen,Valor),
					brk(Valor,NPoblacion,Final),
					(member(NuevoGen,NPoblacion) -> (generarPoblacion([],NPoblacion,Final));
													(generarPoblacion(NuevoGen,NPoblacion,Final))))).

/*Entrada del algoritmo. Los únicos parámetros que le entran son los datos numéricos
 de la canción inicial en una lista y los datos numéricos de la canción final en otra
  lista. Éste método manda a llamar al siguiente que es generaPoblación*/
algGenerico(Inicial,Final):-
	generarPoblacion(Inicial,[],Final).


