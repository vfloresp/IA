%combina(i,i,o)
combina([],Lista,Lista):-
        !.
combina([X|Lista1],Lista2,[X | Lista3]):-
    combinar(Lista1,Lista2,Lista3).

