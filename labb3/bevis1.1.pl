% For SICStus, uncomment line below: (needed for member/2)
%:- use_module(library(lists)).
% Load model, initial state and formula from file.
verify(Input) :-
    see(Input), read(T), read(L), read(S), read(F), seen,
    check(T, L, S, [], F).
    % check(T, L, S, U, F)
    % T - The transitions in form of adjacency lists
    % L - The labeling
    % S - Current state
    % U - Currently recorded states
    % F - CTL Formula to check.
    %
    % Should evaluate to true iff the sequent below is valid.
    %
    % (T,L), S |- F
    % U
    % To execute: consult('your_file.pl'). verify('input.txt').
     

%         ['run_all_tests.pl'].
 %          run_all_tests('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb3\\bevis1.1.pl').

 % i swipl:
 % consult('C:\\Users\\Johan\\OneDrive\\Documents\\prolog\\labb3\\bevis1.1.pl').
 % verify('C:/Users/Johan/OneDrive/Documents/Prolog/labb3/tests/valid004.txt').
     
    % ---------------------------------------
    % Literals
    check(_, L, S, [], X) :-
        member([S,StateLabel], L),
        member(X,StateLabel).

    check(T, L, S, [], neg(X)) :-
        \+check(T,L,S,[],X).
    % And
    check(T, L, S, [], and(F,G)) :-
        check(T,L,S,[],F),
        check(T,L,S,[],G).
    % Or
    check(T,L,S,[],or(F,G)) :-
        (check(T,L,S,[],F) ; check(T,L,S,[],G)).
     
    % AX
    check(T,L,S,[],ax(X)) :-
        \+ check(T,L,S,[],ex(neg(X))).
     
    % EX
    check(T,L,S,[],ex(X)) :-
        member([S,Neighbors], T), %get adjacent states of S
        member(Next,Neighbors), %get one of the states of adjacent states of S
        check(T,L,Next,[],X).   %check for this state
    % AG
    check(T,L,S,U,ag(X)) :-
        member(S,U);
        (\+ member(S,U),
        \+ check(T,L,S,U,ef(neg(X)))).
     
    % EG
    check(T,L,S,U,eg(X)) :-
        member(S,U);
        (\+ member(S,U),
        check(T,L,S,[],X),
        member([S,Neighbors],T),
        member(Next,Neighbors),
        check(T,L,Next,[S|U], eg(X))).
     
    
    % EF
check(T,L,S,U,ef(X)) :-
    \+ member(S,U),  
    check(T,L,S,[],X);
    (\+ member(S,U),
    member([S,Neighbors],T),
    member(Next,Neighbors),
    check(T,L,Next,[S|U],ef(X))).
    % AF
    check(T,L,S,U,af(X)) :-
        \+ member(S,U),
        \+ check(T,L,S,U,eg(neg(X))).
     
    