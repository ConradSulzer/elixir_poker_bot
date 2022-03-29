defmodule PokerWeb.SlashController do
  @moduledoc """
  controller for interacting with slack slash commands
  """

  use PokerWeb, :controller

  alias Poker.SlashCommands

  def index(conn, %{"text" => text, "channel_id" => channel}) do
    result =
      text
      |> String.trim()
      |> SlashCommands.execute_command(channel)

    json(conn, result)
  end
end
