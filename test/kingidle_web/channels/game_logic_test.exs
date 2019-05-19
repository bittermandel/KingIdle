defmodule KingidleWeb.GameLogicSocketTest do
  use KingidleWeb.ChannelCase

  #setup do
    #{:ok, _, socket} =
    #  socket(KingidleWeb.UserSocket, "user", %{userid: 0})
    #  connect(handler, params, connect_info \\ quote do %{} end)
    #{:ok, socket: socket}

  #end

  test "ping replies with status ok" do
    {:ok, socket} = connect(KingidleWeb.UserSocket, %{userid: 0})
    :timer.sleep(5000)
    :ok
  end
end


