verify(InputFileName) :-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof, Proof, Boxproof).
    
 % i cmd:
 % swipl -g "['C:/Users/Johan/OneDrive/Documents/prolog/labb2/natural.pl'], verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt')" -g halt


 % i swipl:
 % consult('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb2\\natural.pl').
 % verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt').

 
valid_proof(Prems, Goal, [H|T], Wholeproof, Boxproof) :-
    (box(Prems,H,Boxproof);
    premise(Prems, H);
    eval(H,Wholeproof);
    eval1(H, Boxproof);
    lem(H)),
    valid_proof(Prems, Goal, T, Wholeproof, Boxproof).

  valid_proof(Prems, Goal, [T], Wholeproof, Boxproof) :-
    (premise(Prems, T);
    eval(T,Wholeproof);
    lem(T);
    eval1(T, Boxproof)),
    goal(T, Goal).

premise(Prems, [_,X,premise]) :-
    write('hejsan!   '),
    member(X, Prems).

%impint
eval1([Row,imp(X,Y),impint(Row1,Row2)], Boxproof):-
    Row>Row1,Row>Row2,
    member([Row1,X,assumption],Boxproof),
    member([Row2,Y,_],Boxproof),
write('     bajs!!!!    ').

%impel
eval([Row,X,impel(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row1, imp(Y,X), _], Wholeproof),
    member([Row2, Y, _], Wholeproof).

%andel1
eval([Row,X,andel1(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(X,_),_], Wholeproof).

%andel2
eval([Row,X,andel2(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(_,X),_], Wholeproof).

%orint1
eval([Row, or(X,_), orint1(Row1,_)], Wholeproof):-
    Row>Row1;
    member([Row1, X, _], Wholeproof).

%orint2
eval([Row, or(_,Y), orint2(_,Row2)], Wholeproof):-
    Row>Row2;
    member([Row2, Y, _], Wholeproof).

%andint
eval([Row,and(X,Y),andint(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row2, X, _], Wholeproof),
    member([Row1, Y, _], Wholeproof).

%negint
eval([Row,neg(X), negint(Row1,Row2)], Boxproof):-
    Row>Row1, Row>Row2,
    member([Row1,X,assumption], Boxproof),
    member([Row2,cont,_], Boxproof).

%negel
eval([Row, cont, negel(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    ((member([Row1, X, _],Wholeproof),
     member([Row2, neg(X), _],Wholeproof));
    (member([Row1, neg(X), _],Wholeproof),
     member([Row2, X, _],Wholeproof))).

%negnegel
eval([Row, X, negnegel(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, neg(neg(X)), _], Wholeproof).

%negnegint
eval([Row, neg(neg(X)), negnegint(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, X, _], Wholeproof).

%contel
eval([Row, _ , contel(Row1)], Wholeproof) :-
    Row>Row1,
    member([Row1, cont, _], Wholeproof).

%mt
eval([Row, neg(X), mt(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    ((member([Row1, imp(X,Y), _],Wholeproof),
      member([Row2, neg(Y), _],Wholeproof));
     (member([Row1, neg(Y), _],Wholeproof),
      member([Row2, imp(X,Y), _],Wholeproof))),
    write('MT!!!!      ').

lem([_,or(X, neg(X)),lem]):-
    1==1,
    write('lem!!!   ').

%copy([Row, X, copy(Row1)], Wholeproof):-
 %   Row>Row1,
  %  member([Row1,X,_],Wholeproof),
   % write('horcopy').
%-----------------------------------------------------------
box(Prems,[[Row,X,assumption]|T],Boxproof):-
    append([[Row,X,assumption]|T],[],Boxproof),
    valid_box(Prems, T, Boxproof ),
    write('hejsan hora').

valid_box(Prems, [H|T], Boxproof) :-
    (box(Prems,H,Boxproof);
    premise(Prems, H);
    eval(H,Boxproof);
    lem(H)),
    valid_box(Prems, T, Boxproof).

valid_box(Prems, [T|[]], Boxproof) :-
    (premise(Prems, T);
    eval(T,Boxproof);
    lem(T)).
%--------------------------------------------------------

goal([_,X,_],Goal):-
    X == Goal,
    write('predikatet uppfyllt!').