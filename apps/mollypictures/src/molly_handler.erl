-module(molly_handler).

-behaviour(cowboy_http_handler).

-export([init/2]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {}).

%%====================================================================
%% API
%%====================================================================

init(Req, Opts) ->

  {Width, Height, Format} = cowboy_req:binding(image_spec, Req),

  Path = random_picture_path(),
  {_, Image} = command_runner:exec(image_command(Width, Height, Format, Path)),

  Req2 = cowboy_req:reply(200,
    #{ <<"content-type">> => mime_type(Format) }, Image, Req),

  {ok, Req2, #state{}}.


handle(Req, State=#state{}) ->
  {ok, Req2} = cowboy_req:reply(200, Req),
    {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.


%%====================================================================
%% Internal functions
%%====================================================================

%% Path to random molly picture
random_picture_path() ->
  %% TODO: portrait vs landscape
  %% TODO: file.expand_path...
  Basepath = filename:join([code:priv_dir(mollypictures), "images"]),
  {_, Pictures} = file:list_dir(Basepath),

  random:seed(erlang:now()),

  Index = random:uniform(length(Pictures)),
  File = lists:nth(Index, Pictures),

  filename:join([Basepath, File]).


image_command(Width, Height, Format, Path) ->
  Dimensions = string:join([Width, "x", Height], ""),
  Resize = string:join([Dimensions, "^"], ""),

  Command = string:join([
    "convert",
    Path,
    "-resize", Resize,
    "-gravity Center",
    "-extent", Dimensions,
    string:join([Format, ":-"], "")
  ], " ").

mime_type(Format) ->
  list_to_binary(string:join(["image", Format], "/")).
