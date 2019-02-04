%assert(hecho o regla)
%retract eliminar de la base de conocimiento
%:- dynamic (predicado)
%
%Aridad el número de elementos que contiene una clausula.

:-dynamic pais/1.

pais(holanda).
pais(francia).

repite.
repite:-
    repite.

escribe_paises:-
    pais(X),
    X\==ya,
    write(X),
    nl,
    fail.
escribe_paises.

main:-
    write("Dame los nombres de varios "),
    write("paises y escribe ya cuando "),
    write("quieras terminar: "),nl,
    repite,
    read(Pais),
    assert(pais(Pais)),
    Pais==ya,
    escribe_paises.

