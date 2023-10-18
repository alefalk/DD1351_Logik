verify(InputFileName) :-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof, Proof).
    
 % i cmd:
 % swipl -g "['C:/Users/Johan/OneDrive/Documents/prolog/labb2/natural.pl'], verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt')" -g halt


 % i swipl:
 % consult('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb2\\natural.pl').
 % verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt').

 
valid_proof(Prems, Goal, [H|T], Wholeproof) :-
    (premise(Prems, H);
    impel(H,Wholeproof);
    andel1(H,Wholeproof);
    andel2(H,Wholeproof);
    andint(H,Wholeproof);
    orint1(H,Wholeproof);
    orint2(H,Wholeproof);
    negel(H,Wholeproof);
    contel(H,Wholeproof);
    negnegel(H,Wholeproof);
    negnegint(H,Wholeproof);
    mt(H,Wholeproof);
    lem(H)),
    valid_proof(Prems, Goal, T, Wholeproof).

  valid_proof(Prems, Goal, [T], Wholeproof) :-
    (premise(Prems, T);
    impel(T,Wholeproof);
    andel1(T,Wholeproof);
    andel2(T,Wholeproof);
    andint(T,Wholeproof);
    orint1(T,Wholeproof);
    orint2(T,Wholeproof);
    negel(T,Wholeproof);
    contel(T,Wholeproof);
    negnegel(T,Wholeproof);
    negnegint(T,Wholeproof);
    mt(T,Wholeproof);
    lem(T)),
    goal(T, Goal).

premise(Prems, [_,X,premise]) :-
    write('hejsan!   '),
    member(X, Prems).

impel([Row,X,impel(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row1, imp(Y,X), _], Wholeproof),
    member([Row2, Y, _], Wholeproof).

andel1([Row,X,andel1(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(X,_),_], Wholeproof).

andel2([Row,X,andel2(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(_,X),_], Wholeproof).

orint1([Row, or(X,_), orint1(Row1,_)], Wholeproof):-
    Row>Row1;
    member([Row1, X, _], Wholeproof).

orint2([Row, or(_,Y), orint1(_,Row2)], Wholeproof):-
    Row>Row2;
    member([Row2, Y, _], Wholeproof).

andint([Row,and(X,Y),andint(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row2, X, _], Wholeproof),
    member([Row1, Y, _], Wholeproof).

negel([Row, cont, negel(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    ((member([Row1, X, _],Wholeproof),
     member([Row2, neg(X), _],Wholeproof));
    (member([Row1, neg(X), _],Wholeproof),
     member([Row2, X, _],Wholeproof))).

negnegel([Row, X, negnegel(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, neg(neg(X)), _], Wholeproof).

negnegint([Row, neg(neg(X)), negnegint(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, X, _], Wholeproof).

contel([Row, _ , contel(Row1)], Wholeproof) :-
    Row>Row1,
    member([Row1, cont, _], Wholeproof).

mt([Row, neg(X), mt(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    ((member([Row1, imp(X,Y), _],Wholeproof),
      member([Row2, neg(Y), _],Wholeproof));
     (member([Row1, neg(Y), _],Wholeproof),
      member([Row2, imp(X,Y), _],Wholeproof))),
    write('MT!!!!      ').

lem([_,or(X, neg(X)),lem]):-
    1==1,
    write('lem!!!   ').

goal([_,X,_],Goal):-
    X == Goal,
    write('predikatet uppfyllt!').