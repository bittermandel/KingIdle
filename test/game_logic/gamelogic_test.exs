defmodule Kingidle.GameLogicTest do
  use ExUnit.Case
  require Logger

  setup do
    {:ok, game} = Kingidle.GameLogic.start_link(0)
    %{game: game}
  end

  test "can change skill", %{game: game} do
    assert Kingidle.GameLogic.get_skill(0) == :nil
    assert Kingidle.GameLogic.change_skill(0, :strength)
    assert Kingidle.GameLogic.get_skill(0) == :strength
  end
end
