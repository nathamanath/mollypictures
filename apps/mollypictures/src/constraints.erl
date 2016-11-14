-module(constraints).

-export([image_spec/1]).

-define(MAX_WIDTH, 1920).
-define(MAX_HEIGHT, 1080).

%%====================================================================
%% API
%%====================================================================

image_spec(Value) ->

  String = binary_to_list(Value),

  case re:run(String, "^(\\d+)x(\\d+).(png|jpeg)+$") of
    {match, Matches} ->

      Width = match_text(String, lists:nth(2, Matches)),
      Height = match_text(String, lists:nth(3, Matches)),
      Format = match_text(String, lists:nth(4, Matches)),
      Orientation = get_orientation(Width, Height),

      output(Width, Height, Format, Orientation);

    _ -> false
  end.

%%====================================================================
%% Internal functions
%%====================================================================

match_text(String, {From, To}) ->
  lists:sublist(String, From+1, To).

%% Validate equested dimensions
valid_dimens(Width, Height) when is_list(Width), is_list(Height) ->
  valid_dimens(list_to_integer(Width), list_to_integer(Height));

valid_dimens(Width, _Height) when Width > ?MAX_WIDTH -> false;
valid_dimens(_Width, Height) when Height > ?MAX_HEIGHT -> false;
valid_dimens(_Width, _Height) -> true.


output(Width, Height, Format, Orientation) ->

  case valid_dimens(Width, Height) of
    true -> {true, {Width, Height, Format, Orientation}};
    _ -> false
  end.

%% Work out if portrait or landscape image has been requested
get_orientation(Width, Height) when is_list(Width), is_list(Height) ->
  get_orientation(list_to_integer(Width), list_to_integer(Height));

get_orientation(Width, Height) when Width >= Height -> landscape;
get_orientation(_Width, _Height) -> portrait.
