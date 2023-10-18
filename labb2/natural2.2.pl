verify(InputFileName) :-
    see(InputFileName),
    read(Prems), read(Goal), read(Proof),
    seen,
    valid_proof(Prems, Goal, Proof, Proof).
    
 % i cmd:
 % swipl -g "['C:/Users/Johan/OneDrive/Documents/prolog/labb2/natural.pl'], verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt')" -g halt

 %         ['run_all_tests.pl'].
 %          run_all_tests('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb2\\natural2.2.pl').

 % i swipl:
 % consult('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb2\\natural.pl').
 % verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb2/input.txt').



 valid_proof(Prems, Goal, [T|[]], Wholeproof) :-
    (premise(Prems, T);
    eval(T,Wholeproof);
    lem(T)),
    goal(T, Goal).

valid_proof(Prems, Goal, [H|T], Wholeproof) :-
    (box(Prems,H, Wholeproof);
    premise(Prems, H);
    eval(H,Wholeproof);
    lem(H)),
    valid_proof(Prems, Goal, T, Wholeproof).

%-----------------------------------------------------------
%Vi skickar med Wholeproof i Box eftersom copy kan behöva wholeproof för 
%att kopiera en premiss
box(Prems,[[Row,X,assumption]|T] , Wholeproof):-
  (T==[]);
  (append([[Row,X,assumption]|T],Wholeproof, Boxproof),
  valid_box(Prems, T, Boxproof , Wholeproof)).
    %write('   KLAR BOX   ').


valid_box(Prems, [T], Boxproof , Wholeproof) :-
    (premise(Prems, T);
    eval(T,Boxproof);
    lem(T);
    copy(T,Boxproof, Wholeproof)).

valid_box(Prems, [H|T] ,Boxproof, Wholeproof) :-
    (box(Prems , H , Boxproof), 
    append(H,Boxproof,Finalproof),
    valid_box(Prems, T, Finalproof, Wholeproof));
    
    (premise(Prems, H);
    eval(H,Boxproof);
    lem(H);
    copy(H,Boxproof, Wholeproof)),
    valid_box(Prems, T, Boxproof, Wholeproof).
%--------------------------------------------------------

ifbox([[Row,X,assumption]|T] , Checklist, Row):-
  append([[Row,X,assumption]|T] , [], Checklist).

findbox([H|T], Checklist, Row):-
  ifbox(H, Checklist , Row);
  findbox(T,Checklist, Row).

premise(Prems, [_,X,premise]) :-
    member(X, Prems).
  %  write('   KLAR PREMISE   ').

%orel
eval([Row, X, orel(Row1,Row2a,Row2b,Row3a,Row3b)], Boxproof) :-
    findbox(Boxproof, ChecklistA, Row2a),
    findbox(Boxproof, ChecklistB, Row3a),
    Row>Row1, Row>Row2a, Row>Row2b, Row>Row3a, Row>Row3b,
    member([Row1,or(P,Q),_], Boxproof),
    member([Row2a,P,assumption], ChecklistA),
    member([Row2b,X,_], ChecklistA),
    member([Row3a,Q,assumption], ChecklistB),
    member([Row3b,X,_], ChecklistB).
   % write('   KLAR OREL   ').

%pbc
eval([Row,X,pbc(Row1,Row2)], Boxproof):-
  findbox(Boxproof, Checklist, Row1),
    Row>Row1,Row>Row2,
    member([Row1,neg(X), assumption], Checklist),
    member([Row2,cont, _], Checklist).
  %  write('     KLAR PBC    ').

%impint
eval([Row,imp(X,Y),impint(Row1,Row2)], Boxproof):-
  findbox(Boxproof, Checklist, Row1),
  Row>Row1,Row>Row2,
  member([Row1,X,assumption],Checklist),
  member([Row2,Y,_],Checklist).
 % write('     KLAR IMPINT    ').

%impel
eval([Row,X,impel(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row1, imp(Y,X), _], Wholeproof),
    member([Row2, Y, _], Wholeproof).
  %  write('     KLAR IMPEL    ').

%andel1
eval([Row,X,andel1(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(X,_),_], Wholeproof).
  %  write('     KLAR ANDEL1    ').

%andel2
eval([Row,X,andel2(Rownum)], Wholeproof) :-
    Row>Rownum,
    member([Rownum,and(_,X),_], Wholeproof).
  %  write('     KLAR ANDEL2    ').

%orint1
eval([Row, or(X,_), orint1(Row1,_)], Wholeproof):-
    Row>Row1,
    member([Row1, X, _], Wholeproof).
   % write('     KLAR ORINT1    ').

%orint2
eval([Row, or(_,Y), orint2(_,Row2)], Wholeproof):-
    Row>Row2,
    member([Row2, Y, _], Wholeproof).
  %  write('     KLAR ORINT2    ').

%andint
eval([Row,and(X,Y),andint(Row2,Row1)], Wholeproof) :-
    Row>Row1,Row>Row2,
    member([Row2, X, _], Wholeproof),
    member([Row1, Y, _], Wholeproof).

  %  write('   KLAR ANDINT   ').

%negint
eval([Row,neg(X), negint(Row1,Row2)], Boxproof):-
    findbox(Boxproof, Checklist, Row1),
    Row>Row1, Row>Row2,
    member([Row1,X,assumption], Checklist),
    member([Row2,cont,_], Checklist).
  %  write('    KLAR NEGINT    ').

%negel
eval([Row, cont, negel(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    member([Row2, neg(X), _],Wholeproof),
    member([Row1, X, _],Wholeproof).
  %  write('     KLAR NEGEL    ').

%negnegel
eval([Row, X, negnegel(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, neg(neg(X)), _], Wholeproof).
  %  write('     KLAR NEGNEGEL    ').

%negnegint
eval([Row, neg(neg(X)), negnegint(Row1)], Wholeproof):-
    Row>Row1,
    member([Row1, X, _], Wholeproof).
  %  write('     KLAR NEGNEGINT    ').

%contel
eval([Row, _ , contel(Row1)], Wholeproof) :-
    Row>Row1,
    member([Row1, cont, _], Wholeproof).
  %  write('     KLAR CONT    ').

%mt
eval([Row, neg(X), mt(Row1,Row2)], Wholeproof):-
    Row>Row1, Row>Row2,
    member([Row1, imp(X,Y), _],Wholeproof),
    member([Row2, neg(Y), _],Wholeproof).
  %  write('   KLAR MT   ').

lem([_,or(X, neg(X)),lem]):-
    1==1.
  %  write('   KLAR LEM   ').

copy([Row, X, copy(Row1)], Boxproof, Wholeproof ) :-
  Row>Row1,
  member([Row1, X, premise], Wholeproof);
  (findbox(Boxproof, Checklist, Row),
  member([Row1,X,assumption], Checklist)).
%  write(' COPY').

goal([_,X,_],Goal):-
    X == Goal.
  %  write('predikatet uppfyllt!').