defmodule Poker.Github do
  @moduledoc """
  a module for functions relating to interacting with GitHub
  """

  def get_client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, Application.get_env(:poker, :github_api_url)},
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "token #{Application.get_env(:poker, :github_access_token)}"},
         {"Accept", "application/vnd.github.v3+json"}
       ]},
      {Tesla.Middleware.Timeout, timeout: 10_000},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  def get_issue(issue_number) do
    with {:ok, response} <-
           Tesla.get(
             get_client(),
             "#{Application.get_env(:poker, :github_issue_path)}#{issue_number}"
           ) do
      params = Map.take(response.body, ["title", "url"])
      {:ok, params}
    else
      {:error, message} -> {:error, message}
    end
  end

  def add_label(issue_number, label) do
    with {:ok, response} <-
           Tesla.post(
             get_client(),
             "#{Application.get_env(:poker, :github_issue_path)}#{issue_number}/labels",
             %{labels: [label]}
           ) do
      {:ok, "Label added."}
    else
      {:error, message} -> {:error, message}
    end
  end
end
