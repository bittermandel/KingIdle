defmodule Kingidle.GameLogic do
  use GenServer
  require Logger

  def start_link(userid, socket) do
    GenServer.start_link(__MODULE__, {userid, socket}, name: {:global, {:userid, userid}})
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
  def init({userid, socket}) do
    Logger.debug("Game started for #{userid}")
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
  def handle_info(:loop, %{userid: userid, activeSkill: activeSkill, skills: skills}) do
    skills = Map.update(skills, activeSkill, 1, &(&1 + 1))
    Logger.info "#{inspect(activeSkill)} has been leveled up for user #{userid}: #{skills[activeSkill]}"
    KingidleWeb.Endpoint.broadcast("game:#{userid}", "level_up", %{activeSkill: skills[activeSkill]})
    schedule_loop()
    {:noreply, %{userid: userid, activeSkill: activeSkill, skills: skills}}
  end

  defp schedule_loop do
    Process.send_after(self(), :loop, 1000)
  end
end
