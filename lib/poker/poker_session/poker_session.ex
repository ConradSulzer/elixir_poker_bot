defmodule Poker.PokerSession do
  @moduledoc """
  genserver to manage poker session.
  """

  use GenServer

  alias Poker.Github
  alias Poker.PokerSession.PokerMessenger

  @initial_state %{
    voters: %{},
    issue: nil,
    title: nil,
    issue_link: nil,
    channel: nil,
    ts: nil
  }

  # Server
  def init(state) do
    {:ok, state}
  end

  def handle_call(:get, _from, state), do: {:reply, state, state}

  def handle_cast(:reset, _state), do: {:noreply, @initial_state}

  def handle_cast(
        {:set_issue, %{issue: issue_number} = params},
        current_state
      ) do
    with {:ok, %{"title" => title, "html_url" => url}} <- Github.get_issue(issue_number) do
      params =
        @initial_state
        |> Map.merge(params)
        |> Map.put(:title, title)
        |> Map.put(:issue_link, url)

      {:ok, _channel, ts} = PokerMessenger.send_initial_card(params)

      {:noreply, Map.put(params, :ts, ts)}
    else
      {:error, _message} -> {:noreply, current_state}
    end
  end

  def handle_cast({:vote, vote}, current_state) do
    IO.inspect(current_state, label: "CURRENT STATE")

    state =
      current_state.voters
      |> Map.merge(vote)
      |> (&Map.put(current_state, :voters, &1)).()

    IO.inspect(state, label: "THIS IS STATE")

    PokerMessenger.send_new_vote(state)

    {:noreply, state}
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

  def vote(user_id, value) do
    GenServer.cast(:poker, {:vote, %{"#{user_id}" => value}})
  end
end
