defmodule WeekendWeb.RoomChannel do
  use WeekendWeb, :channel

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body, "tokenNum" => tokenNum}, socket) do
    broadcast!(socket, "new_msg", %{body: body, tokenNum: tokenNum})
    {:noreply, socket}
  end

  def handle_in("shout", payload, socket) do
    Weekend.Message.changeset(%Weekend.Message{}, payload) |> Weekend.Repo.insert()
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Weekend.Message.get_messages()
    |> Enum.reverse()
    |> Enum.each(fn msg ->
      push(socket, "old_message", %{
        name: msg.name,
        message: msg.message
      })
    end)

    # :noreply
    {:noreply, socket}
  end

  #
  #  @impl true
  #  def join("room:*", payload, socket) do
  #    if authorized?(payload) do
  #      {:ok, socket}
  #    else
  #      {:error, %{reason: "unauthorized"}}
  #    end
  #  end
  #  def join("room:lobby", _message, socket) do
  #    {:ok, socket}
  #  end
  #
  #  def join("room:" <> _private_room_id, _params, _socket) do
  #    {:error, %{reason: "unauthorized"}}
  #  end
  #  # Channels can be used in a request/response fashion
  #  # by sending replies to requests from the client
  #  @impl true
  #  def handle_in("ping", payload, socket) do
  #    {:reply, {:ok, payload}, socket}
  #  end
  #
  #  # It is also common to receive messages from the client and
  #  # broadcast to everyone in the current topic (room:lobby).
  #  @impl true
  #  def handle_in("shout", payload, socket) do
  #    broadcast(socket, "shout", payload)
  #    {:reply, {:ok, payload}, socket}
  #  end
  #
  #  # Add authorization logic here as required.
  #  defp authorized?(_payload) do
  #    true
  #  end
end
