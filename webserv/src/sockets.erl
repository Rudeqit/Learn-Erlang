-module(sockets).

-export([start_link/0, start/0, start/1, server/1, accept/2, get_page/0]).

start() ->
    start(8080).

start_link() ->
    server(8080).

start(Port) ->
    spawn(?MODULE, server, [Port]),
    ok.

server(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {packet, 0}, {ip, {192,168,1,4}}]),

    io:format("start server at port ~p~n", [Port]),
    [spawn(?MODULE, accept, [Id, ListenSocket]) || Id <- lists:seq(1, 1000)],
    timer:sleep(infinity),
    ok.

accept(Id, ListenSocket) ->
    io:format("Socket #~p wait for client~n", [Id]),
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    io:format("Socket #~p, session started~n", [Id]),
    handle_connection(Id, ListenSocket, Socket).

handle_connection(Id, ListenSocket, Socket) ->
    Page = get_page(),    

    case gen_tcp:recv(Socket, 0) of
        {ok, Msg} -> 
            io:format("Socket #~p got message: ~p~n", [Id, Msg]),
            gen_tcp:send(Socket, Page),
            handle_connection(Id, ListenSocket, Socket);
        {error, closed} ->
            io:format("Socket #~p, session closed ~n", [Id]),
            accept(Id, ListenSocket)
    end.

get_page() ->
    %<<"HTTP/1.1 200 OK\r\nContent-Length: 12\r\n\r\nhello world!">>.
    {ok, Binary} = file:read_file("priv/www/index.html"),
    Size = erlang:byte_size(Binary),
    BinSize = erlang:integer_to_binary(Size), 
    HTTP = <<"HTTP/1.1 200 OK\r\nContent-Length: ", BinSize/binary, "\r\n\r\n">>,

    <<HTTP/binary, Binary/binary>>.