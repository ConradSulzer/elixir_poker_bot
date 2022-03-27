defmodule Poker.SlashCommands do
  @moduledoc """
  module to handle action for various the slash commands
  """

  def action(["help"], _channel) do
    %{
      type: "mrkdwn",
      response_type: "ephemeral",
      text: """
      Available Commands:
      :clapper: /poker start - starts a poker session.
      .
      :memo: /poker issue [issue number] - sets the github issue for pokering.
      .
      :bomb: /poker reset - clears the current issue and resets to empty state.
      .
      :octagonal_sign: /poker end - ends the poker session.
      """
    }
  end

  def action(["start"], _channel) do
    %{
      type: "mrkdwn",
      response_type: "ephemeral",
      text: """
      Poker session started! Use `/poker issue [issue number]` to set an issue.
      """
    }
  end

  def action(["issue", issue_number], _channel) do

  end

  def action(["reset"], _channel) do

  end

  def action(["end"], _channel) do

  end

  def action(_action, _channel) do

  end
end
