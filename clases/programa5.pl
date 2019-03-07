saludos:-
    prolog_pais(Pais1),
    write(Pais1),
    write(" saluda a: "),nl,!,
    prolog_pais(Pais2),
    Pais2\==Pais1,
    write(Pais2),nl,
    fail.
saludos.
prolog_pais(japon).
prolog_pais(francia).
prolog_pais(hungria).
prolog_pais(bhutan).
prolog_pais(colombia).
prolog_pais(espania).
