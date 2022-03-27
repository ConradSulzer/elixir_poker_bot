defmodule Poker.CacheBodyParser do
  @moduledoc """
  parser for saving the raw body in conn assigns
  """

  def read_body(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], fn _ -> body end)
    {:ok, body, conn}
  end
end
