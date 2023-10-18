partstring([_],0,[]).

partstring(Lista,L,V):-
    subset(Lista,V),
	lenList(V,L).

lenList([],0).
lenList([_|T],N) :- lenList(T,N1), N is N1+1.


check(_, []).
check([H|T], [H|R]) :- check(T, R).
subset([H|T], [H|R]) :- check(T, R).
subset([_|T], R) :- subset(T, R).
