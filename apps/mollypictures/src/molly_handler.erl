-module(molly_handler).

-behaviour(cowboy_http_handler).

-export([init/2]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {}).

-define(MAX_WIDTH_MEDIUM, 960).
-define(MAX_HEIGHT_MEDIUM, 640).

-define(MAX_WIDTH_SMALL, 480).
-define(MAX_HEIGHT_SMALL, 320).

%%====================================================================
%% API
%%====================================================================

init(Req, Opts) ->

  {Width, Height, Format, Orientation} = cowboy_req:binding(image_spec, Req),

  Type = cowboy_req:binding(type, Req, c),
  Size = source_folder(Width, Height, Orientation),

  Path = random_picture_path(Orientation, Size),
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

%% Which size source image do we need
source_folder(Width, Height, portrait) when Width > ?MAX_HEIGHT_MEDIUM -> large;
source_folder(Width, Height, portrait) when Height >= ?MAX_HEIGHT_MEDIUM -> large;
source_folder(Width, Height, landscape) when Width > ?MAX_WIDTH_MEDIUM -> large;
source_folder(Width, Height, landscape) when Height >= ?MAX_HEIGHT_MEDIUM -> large;

source_folder(Width, Height, portrait) when Width > ?MAX_HEIGHT_SMALL -> medium;
source_folder(Width, Height, portrait) when Height >= ?MAX_HEIGHT_SMALL -> medium;
source_folder(Width, Height, landscape) when Width > ?MAX_WIDTH_SMALL -> medium;
source_folder(Width, Height, landscape) when Height >= ?MAX_HEIGHT_SMALL -> medium;

source_folder(_Width, _Height ,_Orientation) -> small.

%% Path to random molly picture
random_picture_path(Orientation, Size) ->
  O = atom_to_list(Orientation),
  S = atom_to_list(Size),

  Basepath = filename:join([code:priv_dir(mollypictures), "images", S, O]),
  {_, Pictures} = file:list_dir(Basepath),

  random:seed(erlang:now()),

  Index = random:uniform(length(Pictures)),
  File = lists:nth(Index, Pictures),

  Out = filename:join([Basepath, File]),
  lager:info(Out),
  Out.

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
