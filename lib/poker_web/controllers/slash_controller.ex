defmodule PokerWeb.SlashController do
  @moduledoc false

  use PokerWeb, :controller

  alias Poker.SlashCommands

  def index(conn, %{"text" => text, "channel_id" => channel}) do
    result =
      text
      |> String.trim()
      |> SlashCommands.execute_command(channel)

    case result do
      nil -> send_resp(conn, 200, "")
      result -> json(conn, result)
    end
  end
end
