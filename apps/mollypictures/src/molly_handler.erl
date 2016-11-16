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

  {Width, Height, Format, Orientation} = cowboy_req:binding(image_spec, Req),

  Type = cowboy_req:binding(type, Req, c),

  Path = random_picture_path(Orientation),
  {_, Image} = command_runner:exec(image_command(Width, Height, Format, Path, Type)),

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

type_flag(Type) when Type =:= g ->
  "-normalize -colorspace Gray";
type_flag(_) -> "".


%% Path to random molly picture
random_picture_path(Path) when is_list(Path) ->
  Basepath = filename:join([code:priv_dir(mollypictures), "images", Path]),
  {_, Pictures} = file:list_dir(Basepath),

  random:seed(erlang:now()),

  Index = random:uniform(length(Pictures)),
  File = lists:nth(Index, Pictures),

  filename:join([Basepath, File]);

random_picture_path(Orientation) when Orientation =:= landscape ->
  random_picture_path("landscape");
random_picture_path(Orientation) ->
  random_picture_path("portrait").

%% Template command for imagemagick
image_command(Width, Height, Format, Path, Type) ->
  W = integer_to_list(Width),
  H = integer_to_list(Height),

  Dimensions = string:join([W, "x", H], ""),
  Resize = string:join([Dimensions, "^"], ""),

  Command = string:join([
    "convert",
    Path,
    "-resize", Resize,
    "-gravity Center",
    "-extent", Dimensions,
    type_flag(Type),
    string:join([Format, ":-"], "")
  ], " ").

mime_type(Format) ->
  list_to_binary(string:join(["image", Format], "/")).
