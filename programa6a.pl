gusta(jorge,X):-
    carne(X).
%gusta(beatriz,X):-
%    X==higado,!,fail.
%gusta(beatriz,X):-
%    carne(X).
gusta(beatriz,X):-
    not(X==higado),carne(X).
carne(pancita).
carne(higado).
carne(filete).
