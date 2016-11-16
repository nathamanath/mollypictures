-module(constraints).

-export([image_spec/1]).

-define(MAX_WIDTH, 1920).
-define(MAX_HEIGHT, 1080).

%%====================================================================
%% API
%%====================================================================

image_spec(Value) ->

  String = binary_to_list(Value),

  case re:run(String, "^(\\d+)x(\\d+)\\.(png|jpeg|jpg|gif)+$") of
    {match, Matches} ->

      Width = list_to_integer(match_text(String, lists:nth(2, Matches))),
      Height = list_to_integer(match_text(String, lists:nth(3, Matches))),
      Format = get_format(match_text(String, lists:nth(4, Matches))),
      Orientation = get_orientation(Width, Height),

      output(Width, Height, Format, Orientation);

    _ -> false
  end.

%%====================================================================
%% Internal functions
%%====================================================================

get_format(Format) when Format =:= "jpg" ->
  get_format("jpeg");
get_format(Format) ->
  Format.

match_text(String, {From, To}) ->
  lists:sublist(String, From+1, To).

%% Validate equested dimensions
valid_dimens(Width, _Height) when Width > ?MAX_WIDTH -> false;
valid_dimens(_Width, Height) when Height > ?MAX_HEIGHT -> false;
valid_dimens(_Width, _Height) -> true.

output(Width, Height, Format, Orientation) ->
  case valid_dimens(Width, Height) of
    true -> {true, {Width, Height, Format, Orientation}};
    _ -> false
  end.

%% Work out if portrait or landscape image has been requested
get_orientation(Width, Height) when Width > Height -> landscape;
get_orientation(_Width, _Height) -> portrait.
