defmodule Poker.Plug.VerifySlack do
  @moduledoc """
  plug for verifying slack bot requests
  """

  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    [timestamp] = get_req_header(conn, "x-slack-request-timestamp")

    with true <- abs(System.os_time(:second) - String.to_integer(timestamp)) < 300,
         true <- validate_signature(conn, timestamp) do
      conn
    else
      _ ->
        conn
        |> send_resp(400, "Unable to process request.")
        |> halt()
    end
  end

  defp validate_signature(conn, timestamp) do
    [slack_signature] = get_req_header(conn, "x-slack-signature")

    timestamp
    |> build_signature_string(conn.assigns.raw_body)
    |> hash_signature_string()
    |> compare_signatures(slack_signature)
  end

  defp build_signature_string(timestamp, body),
    do: "#{Application.get_env(:poker, :slack_version)}:#{timestamp}:#{body}"

  defp hash_signature_string(signature) do
    :hmac
    |> :crypto.mac(:sha256, Application.get_env(:poker, :slack_signing_secret), signature)
    |> Base.encode16()
    |> String.downcase()
    |> (&"v0=#{&1}").()
  end

  defp compare_signatures(signature, slack_signature),
    do: Plug.Crypto.secure_compare(signature, slack_signature)
end
