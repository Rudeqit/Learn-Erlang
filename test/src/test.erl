-module(test).

-export([read_hello_list/1, wait/0, receiver/1, start/0, start_link/0, say_hello/1]).

start_link() ->
    RootPid = self(),
    ReceiverPid = spawn(?MODULE, receiver, [RootPid]),
    [spawn_link(?MODULE, say_hello, [ReceiverPid]) || _ <- lists:seq(1, 5)], %% spawn_link!!!
    io:format("Five threads have been start~n"),
    receive 
        {_, HelloList} -> read_hello_list(HelloList)   
    end.
    % timer:sleep(infinity),
    % ok.

read_hello_list([]) -> ok;
read_hello_list([{Pid, Msg} | Tail]) ->
    io:format("~p: ~p~n", [Pid, Msg]),
    read_hello_list(Tail).

receiver(RootPid) ->
    io:format("Receiver have been started~n"),
    HelloList = [wait() || _ <- lists:seq(1, 5)], 
    RootPid ! {self(), HelloList}.

wait() ->
    io:format("Wait have been started~n"),
    receive
        {Pid, Hi} -> {Pid, Hi}
    end.

say_hello(PPid) ->
    io:format("Hi from ~p~n", [self()]),
    PPid ! {self(), "Hi!"}.

start() ->
    application:start(test).