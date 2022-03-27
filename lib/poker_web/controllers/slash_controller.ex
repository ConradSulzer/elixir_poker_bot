defmodule PokerWeb.SlashController do
  @moduledoc false

  use PokerWeb, :controller

  alias Poker.SlashCommands

  plug(:cache_command)

  @lifecycle_commands ["start", "reset", "end", "help"]

  def index(conn, %{"text" => text, "channel_id" => channel} = params) do
    IO.inspect(params)

    result = SlashCommands.perform_action(String.split(text), channel)

    conn
    |> json(result)
  end

  defp cache_command(%{body_params: %{"text" => "issue" <> rest = issue}} = conn, _opts) do
    IO.inspect(issue, label: "THIS IS ISSUE")
  end

  defp cache_command(%{body_params: %{"text" => text}} = conn, _opts)
       when text in @lifecycle_commands,
       do: IO.inspect("LIFECYCLE GOING")

  defp cache_command(%{body_params: %{"text" => text}} = conn, _opts),
    do:
      conn
      |> json(%{
        type: "mrkdwn",
        response_type: "ephemeral",
        text: """
        Command `#{text}` is not available. Use `/poker help` to view list of available commands.
        """
      })
end
