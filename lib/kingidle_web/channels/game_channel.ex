defmodule KingidleWeb.GameChannel do
  use Phoenix.Channel

  def join("game", _payload, socket) do
    {:ok, "game joined", socket}
  end

  def handle_in("start", _payload, socket) do
    Kingidle.GameLogic.start_link(socket, socket.assigns.guardian_default_resource.id)
    {:noreply, socket}
  end

  def handle_in("change_skill", %{"skill" => skill}, socket) do
    Kingidle.GameLogic.change_skill(socket.assigns.guardian_default_resource.id, skill)
    {:noreply, socket}
  end

end
