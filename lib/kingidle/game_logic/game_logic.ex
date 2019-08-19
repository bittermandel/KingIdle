defmodule Kingidle.GameLogic do
  require Phoenix.Channel
  use GenServer
  require Logger

  def start_link(socket, userid) do
    GenServer.start_link(__MODULE__, {socket, userid}, name: {:global, {:userid, userid}})
  end

  def change_skill(userid, skill) do
    pid = :global.whereis_name({:userid, userid})
    GenServer.call(pid, {:change_skill, skill})
  end

  @spec get_skill(any()) :: any()
  def get_skill(userid) do
    pid = :global.whereis_name({:userid, userid})
    GenServer.call(pid, :get_skill)
  end

  @impl true
  def init({socket, userid}) do
    schedule_loop()
    {:ok, %{
      socket: socket,
      userid: userid,
      activeSkill: nil,
      skills: %{}
    }}
  end

  @impl true
  def handle_call({:change_skill, skill}, _from, state) do
    {:reply, :yes, Map.put(state, :activeSkill, skill)}
  end

  @impl true
  def handle_call(:get_skill, _from, state) do
    {:reply, Map.get(state, :activeSkill), state}
  end

  @impl true
  def handle_call({:get_level, name}, _from, state) do
    {:reply, Map.get(state[:skills], name, 0), state}
  end

  @impl true
  def handle_info(:loop, state = %{activeSkill: nil}) do
    schedule_loop()
    {:noreply, state}
  end

  @impl true
  def handle_info(:loop, %{socket: socket, userid: userid, activeSkill: activeSkill, skills: skills}) do
    skills = Map.update(skills, activeSkill, 1, &(&1 + 1))
    Logger.info "#{inspect(activeSkill)} has been leveled up for user #{userid}: #{skills[activeSkill]}"
    Phoenix.Channel.push(socket, "level_up", %{skill: activeSkill, level: Map.get(skills, activeSkill)})
    # KingidleWeb.Endpoint.broadcast("game:#{userid}", "level_up", %{activeSkill: skills[activeSkill]})
    schedule_loop()
    {:noreply, %{socket: socket, userid: userid, activeSkill: activeSkill, skills: skills}}
  end

  defp schedule_loop do
    Process.send_after(self(), :loop, 1000)
  end
end
