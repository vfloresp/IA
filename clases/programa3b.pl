%valor_max(i,i,o):  input o instantiated  , output o open
%!  para realizar un corte en condiciones mutuamente excluyentes
% elimina el �ltimo punto de retroceso
valor_max(X,Y,X):-
    X>Y,!.
valor_max(_,Y,Y).
