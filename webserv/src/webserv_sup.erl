%%%-------------------------------------------------------------------
%% @doc webserv top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(webserv_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}

% init([]) ->
%     SupervisorSpecification = #{
%         strategy => one_for_one,
%         intensity => 10,
%         period => 60
%     },

%     ChildSpecification =
%         #{id => socket,
%           start => {sockets, start_link, []},
%           restart => permanent,
%           shutdown => 2000,
%           type => worker,
%           modules => [sockets]
%         },

%     {ok, {SupervisorSpecification, ChildSpecification}}.

    % {ok, {{one_for_one, 0, 1}, [
    %     {
            
    %     }
    % ]}}.

init([]) ->
    RestartStrategy = one_for_one, % one_for_one | one_for_all | rest_for_one
    MaxRestarts = 10,
    MaxSecondsBetweenRestarts = 60,
    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent, % permanent | transient | temporary
    Shutdown = 2000,     % brutal_kill | int() >= 0 | infinity
    Type = worker,       % worker | supervisor

    Worker = {socket,
              {sockets, start_link, []},
              Restart, Shutdown, Type,
              [sockets]},

    {ok, {SupFlags, [Worker]}}.

%%====================================================================
%% Internal functions
%%====================================================================
