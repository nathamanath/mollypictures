-module(command_runner).

-export([exec/1]).

exec(Command) ->
  Port = open_port({spawn, Command}, [stream, in, eof, hide, exit_status]),
  get_data(Port, []).

get_data(Port, Sofar) ->
  receive
  {Port, {data, Bytes}} ->
    get_data(Port, [Sofar|Bytes]);
  {Port, eof} ->
    Port ! {self(), close},
    receive
    {Port, closed} ->
      true
    end,
    receive
    {'EXIT',  Port,  _} ->
      ok
    after 1 ->              % force context switch
      ok
    end,
    ExitCode =
      receive
      {Port, {exit_status, Code}} ->
        Code
    end,
    {ExitCode, lists:flatten(Sofar)}
  end.
