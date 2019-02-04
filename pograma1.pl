/* Este es un comentario
 *  en SWI-Prolog */

hombre(jose).
hombre(juan).
mujer(maria).
%El primer argumento es el papá  del segundo
papa(juan,jose).
papa(juan,maria).
valioso(dinero).
dificilDeObtener(dinero).
le_da(pedro,libro,antonio).

hermana(X,Y):-
    papa(Z,X),
    mujer(X),
    papa(Z,Y),
    X\==Y.
humano(X):-
    mujer(X).
humano(X):-
    hombre(X).
