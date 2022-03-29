defmodule PokerWeb.InteractiveController do
  @moduledoc """
  controller for handling slack interactivity
  """

  use PokerWeb, :controller

  plug :parse_payload

  def index(conn, %{
        "actions" => [%{"action_id" => "vote" <> rest}],
        "user" => %{"id" => id}
      }) do
    Poker.PokerSession.vote(id, String.trim(rest))

    send_resp(conn, 200, "")
  end

  defp parse_payload(%{params: params} = conn, _opts) do
    result = Jason.decode!(params["payload"])
    update_in(conn.params, fn _ -> result end)
  end
end
