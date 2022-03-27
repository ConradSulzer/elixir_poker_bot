defmodule Poker.PokerSession do
  @moduledoc """
  genserver to manage poker session
  """

  use GenServer

  @initial_state %{
    voters: []
  }

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_call(:get, _from, current_state) do
    {:reply, current_state, current_state}
  end

  def handle_cast({:set_issue, params}, state) do
    {:noreply, Map.merge(state, params)}
  end

  # Client
  def start() do
    GenServer.start_link(__MODULE__, @initial_state, name: :poker)
  end

  def get_state() do
    GenServer.call(:poker, :get)
  end

  def set_issue(issue_number) do
    GenServer.cast(:poker, {:set_issue, %{issue: issue_number}})
  end
end
