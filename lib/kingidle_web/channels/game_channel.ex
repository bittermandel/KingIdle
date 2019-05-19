defmodule KingidleWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> user_id, _payload, socket) do
    {:ok, "Joined Game:#{user_id}", socket}
  end

  def handle_in("start", payload, socket) do
    IO.inspect(payload)
    {:ok, pid} = Kingidle.GameLogic.start_link(socket.assigns.user_id, socket)
    GenServer.call(pid, {:change_skill, "strength"})
    {:noreply, socket}
  end
end
