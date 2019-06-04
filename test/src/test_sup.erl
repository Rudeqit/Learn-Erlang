-module(test_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, [?CHILD(test, worker)]} }.

% init([]) ->
%     SupervisorSpecification = #{
%         strategy => one_for_one,
%         intensity => 10,
%         period => 60
%     },

%     ChildSpecification =
%         #{id => test,
%           start => {test, start_link, []},
%           restart => permanent,
%           shutdown => 2000,
%           type => worker,
%           modules => [test]
%         },

%     {ok, {SupervisorSpecification, ChildSpecification}}.

% init([]) ->
%     RestartStrategy = one_for_one, % one_for_one | one_for_all | rest_for_one
%     MaxRestarts = 10,
%     MaxSecondsBetweenRestarts = 60,
%     SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

%     Restart = permanent, % permanent | transient | temporary
%     Shutdown = 2000,     % brutal_kill | int() >= 0 | infinity
%     Type = worker,       % worker | supervisor

%     Worker = {test,
%               {test, start_link, []},
%               Restart, Shutdown, Type,
%               [test]},

%     {ok, {SupFlags, [Worker]}}.