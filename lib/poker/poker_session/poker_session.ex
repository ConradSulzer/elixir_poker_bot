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

  def handle_cast({:reset, channel}, state), do: {:noreply, Map.merge(@initial_state, channel)}

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
      _ ->
        PokerMessenger.message_channel(
          current_state,
          "Unable to fetch issue `#{issue_number}`. Make sure `#{issue_number}` is a valid issue and try again."
        )

        {:noreply, current_state}
    end
  end

  def handle_cast({:vote, vote}, current_state) do
    state =
      current_state.voters
      |> Map.merge(vote)
      |> (&Map.put(current_state, :voters, &1)).()

    PokerMessenger.send_new_vote(state)

    {:noreply, state}
  end

  def handle_cast(:reveal, current_state) do
    PokerMessenger.send_reveal(current_state)

    {:noreply, current_state}
  end

  def handle_cast({:add_label, value}, %{issue: issue} = current_state) do
    with {:ok, _message} <- Github.add_label(issue, "points:#{value}") do
      PokerMessenger.send_label_assigned(current_state, value)
      {:noreply, @initial_state}
    else
      _ ->
        PokerMessenger.message_channel(
          current_state,
          "Unable to add label `points:#{value}` to issue `##{issue}`."
        )

        {:noreply, current_state}
    end
  end

  # Client
  def start_link(_) do
    GenServer.start_link(__MODULE__, @initial_state, name: :poker)
  end

  def get_state(), do: GenServer.call(:poker, :get)

  def reset_state(channel), do: GenServer.cast(:poker, {:reset, %{channel: channel}})

  def set_issue(issue_number, channel) do
    GenServer.cast(:poker, {:set_issue, %{issue: issue_number, channel: channel}})
  end

  def vote(user_id, value) do
    GenServer.cast(:poker, {:vote, %{"#{user_id}" => value}})
  end

  def reveal() do
    GenServer.cast(:poker, :reveal)
  end

  def add_label(value) do
    GenServer.cast(:poker, {:add_label, value})
  end
end
