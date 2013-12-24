# WitchWork

** A ChatWork client in Elixir

## How to use

```
$ git clone git@github.com:eitoball/witch_work.git
$ cd witch_work
$ iex -S mix
iex(1)> {:ok, pid} = WitchWork.Server.start_link("Your API key")
iex(2)> rooms = WitchWork.Server.rooms(pid) # for /rooms
iex(3)> tasks = WitchWork.Server.tasks(pid, room_id) # for /rooms/{room_id}/tasks
```
