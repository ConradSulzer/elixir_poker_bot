defmodule Poker.Slack do
  @moduledoc """
  a module for functions relating to interacting with Slack
  """

  def get_client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, Application.get_env(:fillogic, :fedex_api_url)},
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "token #{Application.get_env(:poker, :github_auth_token)}"}
       ]},
      {Tesla.Middleware.Timeout, timeout: 10_000}
    ]

    Tesla.client(middleware)
  end
end
