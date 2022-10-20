-module(beso_exer5).
-export([main/0]).

% the raw part of the recursive prime process
isprimeraw(1, 0) -> io:format("1 - no~n");
isprimeraw(2, 1) -> io:format("2 - prime~n");
isprimeraw(N, 2) when (N rem 2) =/= 0 ->
    io:format("~B - prime~n", [N]);
isprimeraw(N, Check) ->
    if
        (N rem Check) =:= 0 -> io:format("~B - no~n", [N]);
        (N rem Check) =/= 0 -> isprimeraw(N, Check-1)
    end.

% determines whether a number is prime
isprime(N) -> isprimeraw(N, N-1).

% the list version of the is prime
isprimelist([]) -> io:format("Done.~n");
isprimelist([H|L]) -> isprime(H), isprimelist(L).

% raw for each line
% K for the kth char in the Mth line
% L is the leftside value
% the values for the next line is stored in accnew

pascalrawline(K, M, L, [H|Accold], Accnew) ->
    if
        K =:= 0 -> io:format("1 "), Accnew++[1], pascalrawline(K+1, M, H, Accold, Accnew);
        K < M   -> io:format("~B ", [L+H]), Accnew++[L+H], pascalrawline(K+1, M, H, Accold, Accnew);
        K =:= M -> io:format("~n")
    end.

% pascal triangle raw
pascaltriangleraw(0, N, []) when 0 >= N ->
    io:format("1 ~n");
pascaltriangleraw(M, N, Acc) when M =< N ->
    Accnew = [],
    pascalrawline(0, M, 1, Acc, Accnew),
    pascaltriangleraw(M+1, N, Acc).

% pascal triangle
pascaltriangle(N) ->
    Acc = [],
    pascaltriangleraw(0, N, Acc).


% the main program for testing
main() ->
    isprimelist([3, 6, 9, 1, 2]).
    %pascaltriangle(2).