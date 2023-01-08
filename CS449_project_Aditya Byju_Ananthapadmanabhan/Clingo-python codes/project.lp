% Effective PCB Design

% placement of components everywhere
1{place(Name,1..n,1..n,1..n,1..n)}1 :- comp(Name,Con1,Con2).
:-place(X,A,B,C,D),(A+1,B+1)!=(C,D).

:-place(X1,A1,B1,C1,D1),place(X2,A2,B2,C2,D2),A1=A2,B1=B2,X1!=X2.

% placement of wires everywhere
2{wplace(1..4,1..4,1..n,1..n,1..n,1..n)}.
:-wplace(X,Y,A,B,C,D),(A+1,B+1)!=(C,D).
:-wplace(X,Y,A,B,C,D),X=Y.

:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X11=X12,Y11=Y12,X21=X22,Y21=Y22,B1!=B2.
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X11=X12,Y11=Y12,X21=X22,Y21=Y22,A1!=A2.

:-wplace(A1,B1,X11,Y11,X21,Y21),place(A2,X12,Y12,X22,Y22),X11=X12,Y11=Y12,X21=X22,Y21=Y22.

% connect wires adjacently
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,A1=1,B2!=3.
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,A1!=1,B2=3.

:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,B1=1,A2!=3.
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,B1!=1,A2=3.

:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,A1=2,B2!=4.
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,A1!=2,B2=4.

:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,B1=2,A2!=4.
:-wplace(A1,B1,X11,Y11,X21,Y21),wplace(A2,B2,X12,Y12,X22,Y22),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,B1!=2,A2=4.

% every component should be connected by 2 adjacent wires
:- place(X,A,B,C,D), not 2{wplace(4,_,A+1,B,C+1,D); wplace(3,_,A,B+1,C,D+1); wplace(2,_,A-1,B,C-1,D); wplace(1,_,A,B-1,C,D-1); wplace(_,4,A+1,B,C+1,D); wplace(_,3,A,B+1,C,D+1); wplace(_,2,A-1,B,C-1,D); wplace(_,1,A,B-1,C,D-1)}2.

% empty cells marked to eliminate models that have open loops
empty(A,B,C,D) :- not place(_,A,B,C,D), not wplace(_,_,A,B,C,D), A=0..n+1, B=0..n+1, C=0..n+1, D=0..n+1, C=A+1, D=B+1.

:- wplace(X,_,A,B,C,D), X=1, empty(A,B+1,C,D+1).
:- wplace(X,_,A,B,C,D), X=2, empty(A+1,B,C+1,D).
:- wplace(X,_,A,B,C,D), X=3, empty(A,B-1,C,D-1).
:- wplace(X,_,A,B,C,D), X=4, empty(A-1,B,C-1,D).

:- wplace(_,Y,A,B,C,D), Y=1, empty(A,B+1,C,D+1).
:- wplace(_,Y,A,B,C,D), Y=2, empty(A+1,B,C+1,D).
:- wplace(_,Y,A,B,C,D), Y=3, empty(A,B-1,C,D-1).
:- wplace(_,Y,A,B,C,D), Y=4, empty(A-1,B,C-1,D).

% circuit correctness
% same wire components have same node
1{node(X,Y,A,B,C,D,1..no)}1 :- wplace(X,Y,A,B,C,D).
:-node(A1,B1,X11,Y11,X21,Y21,N1),node(A2,B2,X12,Y12,X22,Y22,N2),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,A1=1,B2=3,N1!=N2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),node(A2,B2,X12,Y12,X22,Y22,N2),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,B1=1,A2=3,N1!=N2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),node(A2,B2,X12,Y12,X22,Y22,N2),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,A1=2,B2=4,N1!=N2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),node(A2,B2,X12,Y12,X22,Y22,N2),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,B1=2,A2=4,N1!=N2.

% comp are connected to correct noded wires
:- #count{N : node(_,_,_,_,_,_,N)} != no.
:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,A1=1,N1!=Con1,N1!=Con2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11,Y12=Y11+1,X22=X21,Y22=Y21+1,B1=1,N1!=Con1,N1!=Con2.

:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11,Y12=Y11-1,X22=X21,Y22=Y21-1,A1=3,N1!=Con1,N1!=Con2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11,Y12=Y11-1,X22=X21,Y22=Y21-1,B1=3,N1!=Con1,N1!=Con2.

:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,A1=2,N1!=Con1,N1!=Con2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11+1,Y12=Y11,X22=X21+1,Y22=Y21,B1=2,N1!=Con1,N1!=Con2.

:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11-1,Y12=Y11,X22=X21-1,Y22=Y21,A1=4,N1!=Con1,N1!=Con2.
:-node(A1,B1,X11,Y11,X21,Y21,N1),place(Name,X12,Y12,X22,Y22),comp(Name,Con1,Con2),X12=X11-1,Y12=Y11,X22=X21-1,Y22=Y21,B1=4,N1!=Con1,N1!=Con2.

% minimization of component location
#minimize{(A+B) : place(X,A,B,_,_)}.

% minimization of length of wires
#minimize{1,A,B,C,D : wplace(_,_,A,B,C,D)}.

% minimization of wire location
#minimize{(A+B+C+D) : wplace(_,_,A,B,C,D)}.

% show required output
#show place/5.
#show wplace/6.
#show node/7.
