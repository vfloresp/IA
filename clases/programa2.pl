grande(bisonte).
grande(oso).
grande(elefante).
chico(gato).
cafe(oso).
cafe(bisonte).
negro(gato).
gris(elefante).
oscuro(Z):-
  cafe(Z).
oscuro(Z):-
  negro(Z).

%unificaci�n: se hacen sin�nimo dos variables X=Z
%punto de retroceso: punto en el que debe de retomar una busqueda suspendida.

