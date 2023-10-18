nod(1,2).
nod(2,3).
nod(5,3).
nod(1,6).
nod(6,7).
nod(7,5).

stig(A, B, P) :- 
    stig(A, B, [], P).
stig(A, B, V, P) :-
    nod(A,B),
    append(V, [A, B], P).
stig(A, B, V, P) :-
    nod(A, C),
    \+member(C, V),
    append(V,[A], S),
    stig(C, B, S, P).