-module(prop_base).
-include_lib("proper/include/proper.hrl").

%%%%%%%%%%%%%%%%%%
%%% Properties %%%
%%%%%%%%%%%%%%%%%%
prop_test() ->
    ?FORALL(Type, term(),
        begin
            boolean(Type)
        end).

prop_biggest() ->
    ?FORALL(List, non_empty(list(integer())),
        begin
            biggest(List) =:= lists:last(lists:sort(List))
        end).

prop_sort() ->
    ?FORALL(List, list(term()),
        begin
            is_ordered(lists:sort(List))
        end).

prop_last() ->
    ?FORALL({List, Last}, {list(term()), term()},
        begin
            NewList = lists:append(List, [Last]),
            Last =:= lists:last(NewList)
        end).

prop_keysort() ->
    ?FORALL({List}, {list({term(), non_neg_integer()})},
        begin
            Sorted = lists:keysort(2, List),
            SortedKeys = lists:map(fun({_Value, Key}) -> Key end, Sorted),
            is_ordered(SortedKeys)
        end).

%%%%%%%%%%%%%%%
%%% Helpers %%%
%%%%%%%%%%%%%%%
boolean(_) -> true.

biggest([Head|Tail]) ->
    biggest(Tail, Head).

biggest([], Biggest) ->
    Biggest;
biggest([Head|Tail], Biggest) when Head >= Biggest ->
    biggest(Tail, Head);
biggest([Head|Tail], Biggest) when Head < Biggest ->
    biggest(Tail, Biggest).

is_ordered([A,B|T]) ->
    A =< B andalso is_ordered([B|T]);
is_ordered(_) -> % smaller lists
    true.


%%%%%%%%%%%%%%%%%%
%%% Generators %%%
%%%%%%%%%%%%%%%%%%
mytype() -> term().
