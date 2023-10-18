remove_duplicates([H | T], E) :-
     remove_duplicates( [H|T],[],E).

remove_duplicates([H | T],Temp, E) :- 
    member(H,Temp),
    remove_duplicates( T, Temp,E).

remove_duplicates([H | T],Temp, E) :- 
    \+member(H, Temp),
    append(Temp,[H], C),
    remove_duplicates( T, C,E).

remove_duplicates([],V,E):- append([],V, E).
