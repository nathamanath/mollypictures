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
        "/[:type/]:image_spec",
        [
          {type, fun(V) when V =:= <<"g">> -> {true, g}; (_) -> false end},
          {image_spec, fun constraints:image_spec/1}
        ],
        molly_handler,
        []
      },

      {"/", cowboy_static, {priv_file, mollypictures, "static/index.html"}}
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
