-module(mnesia_test).

-compile(export_all).

-record(users, {id :: integer,
               name :: binary}).


start_test() ->
    init(),
    [write(Id, <<"Arnold">>) || Id <- lists:seq(1, 10)],
    read(users, 1),
    read(users, 10),
    read(users, 11).
    %mnesia:info().

write(Id, Name) ->
    F = fun() ->
            Test1 =  #users{id = Id, name = Name},
            mnesia:write(Test1)
        end,
    {atomic, ok} = mnesia:transaction(F),
    io:format("Write user successfully~n").

% write2(Id, Name) ->
%     Test2 =  #users{id = Id, name = Name},
%     mnesia:dirty_write(Test2).

read(Tab, Key) ->
    F = fun() ->
            mnesia:read(Tab, Key)
        end,
    case mnesia:transaction(F) of 
        {atomic, [{_, Id, Name}]} ->
            ListName = erlang:binary_to_list(Name),
            io:format("User found! {~p, ~p, ~p}~n", [Tab, Id, ListName]);
        _ -> 
            io:format("Error! User with [key = ~p] not found!", [Key])
    end.

init() ->
    application:start(mnesia),
    mnesia:create_schema([erlang:nodes()]),
    mnesia:create_table(users, 
                        [{attributes, record_info(fields, users)}]),
    %% ???
    mnesia:wait_for_tables(users, 1000).
    

stop() ->
    application:stop(mnesia).


