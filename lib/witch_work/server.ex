defmodule WitchWork.Server do
  use GenServer.Behaviour
  use HTTPotion.Base

  def start_link(api_key) do
    :gen_server.start_link(__MODULE__, [api_key], [])
  end

  def rooms(pid) do
    :gen_server.call(pid, :rooms)
  end

  def tasks(pid, room_id) do
    :gen_server.call(pid, {:tasks, room_id})
  end

  def init([api_key]) do
    start
    { :ok, api_key }
  end

  def handle_call(:me, _from, api_key) do
    do_get("/me", api_key)
  end

  def handle_call(:my_status, _from, api_key) do
    do_get("/my/status", api_key)
  end

  def handle_call(:my_tasks, _from, api_key) do
    do_get("/my/tasks", api_key)
  end

  def handle_call(:contacts, _from, api_key) do
    do_get("/contacts", api_key)
  end

  def handle_call(:rooms, _from, api_key) do
    do_get("/rooms", api_key)
  end

  def handle_call({:create_room, attributes}, _from, api_key) do
    body = attributes |> Enum.map(fn { k, v } -> "#{k}=#{v}" end) |> Enum.join("&")
    response = post("/rooms", body, [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:read_room, room_id}, _from, api_key) do
    do_get("/rooms/#{room_id}", api_key)
  end

  def handle_call({:update_room, attributes}, _from, api_key) do
    body = attributes |> Enum.map(fn { k, v } -> "#{k}=#{v}" end) |> Enum.join("&")
    response = put("/rooms", body, [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:leave_room, room_id}, _from, api_key) do
    do_delete_room(room_id, "leave", api_key)
  end

  def handle_call({:delete_room, room_id}, _from, api_key) do
    do_delete_room(room_id, "delete", api_key)
  end

  defp do_delete_room(room_id, action_type, api_key) do
    response = request(:delete, "/rooms/#{room_id}", "action_type=#{action_type}", [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:read_room_members, room_id}, _from, api_key) do
    do_get("/rooms/#{room_id}/members", api_key)
  end

  def handle_call({:update_room_members, room_id, attributes}, _from, api_key) do
    body = attributes |> Enum.map(fn { k, v } -> "#{k}=#{v}" end) |> Enum.join("&")
    response = put("/rooms/#{room_id}/members", body, [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:create_message, room_id, message}, _from, api_key) do
    body = "body=#{message}"
    response = post("/rooms/#{room_id}/messages", body, [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:read_message, room_id, message_id}, _from, api_key) do
    do_get("/rooms/#{room_id}/messages/#{message_id}", api_key)
  end

  def handle_call({:tasks, room_id}, _from, api_key) do
    do_get("/rooms/#{room_id}/tasks", api_key)
  end

  def handle_call({:create_task, room_id, attributes}, _from, api_key) do
    body = attributes |> Enum.map(fn { k, v } -> "#{k}=#{v}" end) |> Enum.join("&")
    response = post("/rooms/#{room_id}/tasks", body, [{:"X-ChatWorkToken", api_key}, {:"Content-Type", "application/x-www-form-urlencoded"}])
    { :reply, response.body, api_key }
  end

  def handle_call({:read_task, room_id, task_id}, _from, api_key) do
    do_get("/rooms/#{room_id}/tasks/#{task_id}", api_key)
  end

  def process_url(url) do
    "https://api.chatwork.com/v1" <> url
  end

  def process_response_body(body) do
    body
    |> to_string
    |> Jsonex.decode
    |> Enum.map fn { k, v } -> { binary_to_atom(k), v } end
  end

  defp do_get(url, api_key) do
    response = get(url, [{:"X-ChatWorkToken", api_key}])
    { :reply, response.body, api_key }
  end
end
