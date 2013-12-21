# WitchWork

** A ChatWork client in Elixir

## How to use

```
$ git clone git@github.com:eitoball/witch_work.git
$ cd witch_work
$ iex -S mix
iex(1)> {:ok, pid} = :gen_server.start_link(WitchWork.Server ["Your API key"], [])
iex(2)> :gen_server.call(:me) # for /me
iex(3)> :gen_server.call({:create_message, {room_id}, "Hello ChatWork!") # for /rooms/{room_id}/messages
```
