%%%-------------------------------------------------------------------
%% @doc mollypictures public API
%% @end
%%%-------------------------------------------------------------------

-module(mollypictures_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

  Dispatch = cowboy_router:compile([
    { '_', [
      {
        "/:image_spec",
        [{image_spec, fun constraints:image_spec/1}],
        molly_handler,
        []
      }
    ]}
  ]),

  {ok, _} = cowboy:start_clear(my_http_handler, 100,
    [{port, 8080}],
    #{env => #{dispatch => Dispatch}}
  ),

  mollypictures_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
  ok.
