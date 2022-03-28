defmodule Poker.Slack do
  @moduledoc """
  a module for functions relating to interacting with Slack
  """

  def get_client() do
    IO.inspect(Application.get_env(:poker, :slack_base_url), label: "THIS IS URL")

    middleware = [
      {Tesla.Middleware.BaseUrl, Application.get_env(:poker, :slack_base_url)},
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Bearer #{Application.get_env(:poker, :slack_bot_oauth_token)}"},
         {"Content-Type", "application/json; charset=utf-8"}
       ]},
      {Tesla.Middleware.Timeout, timeout: 10_000},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  def send_message(message_params) do
    with {:ok, response} <-
           Tesla.post(get_client(), "/chat.postMessage", message_params) do
      %{"channel" => channel, "ts" => timestamp} = response.body
      {:ok, channel, timestamp}
    else
      {:error, message} -> {:error, message}
    end
  end

  def update_message(message_params) do
    with {:ok, response} <-
           Tesla.post(get_client(), "/chat.update", message_params) do
      %{"channel" => channel, "ts" => timestamp} = response.body
      {:ok, channel, timestamp}
    else
      {:error, message} -> {:error, message}
      %{"error" => message} -> {:error, message}
    end
  end
end
