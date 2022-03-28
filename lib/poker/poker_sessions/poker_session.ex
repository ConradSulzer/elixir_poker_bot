defmodule Poker.PokerSession do
  @moduledoc """
  genserver to manage poker session.
  """

  use GenServer

  alias Poker.Github

  @initial_state %{
    voters: [],
    issue: nil,
    title: nil,
    issue_link: nil,
    channel: nil
  }

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_call(:get, _from, state), do: {:reply, state, state}

  def handle_cast(:reset, _state), do: {:noreply, @initial_state}

  def handle_cast(
        {:set_issue, %{issue: issue_number, channel: channel} = params},
        current_state
      ) do
    with {:ok, %{"title" => title, "url" => url}} <- Github.get_issue(issue_number) do
      params =
        params
        |> Map.put(:title, title)
        |> Map.put(:issue_link, url)

      {:noreply, Map.merge(current_state, params)}
    else
      {:error, message} -> {:noreply, current_state}
    end
  end

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, @initial_state, name: :poker)
  end

  def get_state(), do: GenServer.call(:poker, :get)

  def reset_state(), do: GenServer.cast(:poker, :reset)

  def set_issue(issue_number, channel) do
    GenServer.cast(:poker, {:set_issue, %{issue: issue_number, channel: channel}})
  end
end
