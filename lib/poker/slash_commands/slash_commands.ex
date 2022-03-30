defmodule Poker.SlashCommands do
  @moduledoc """
  module to handle actions for various the slash commands
  """

  alias Poker.PokerSession

  def execute_command("help", _channel) do
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
      """
    }
  end

  def execute_command(command, channel) when command in ["start", "reset"] do
    PokerSession.reset_state(channel)

    %{
      type: "mrkdwn",
      response_type: "ephemeral",
      text: """
      Poker session ready! Use `/poker issue [issue number]` to set an issue.
      """
    }
  end

  def execute_command("issue" <> rest, channel) do
    issue_number = String.trim(rest)

    case Integer.parse(issue_number) do
      {x, ""} ->
        PokerSession.set_issue(x, channel)

        %{
          type: "mrkdwn",
          response_type: "in_channel",
          text: """
          :man-running::dash: Fetching issue #{issue_number}...
          """
        }

      _ ->
        %{
          type: "mrkdwn",
          response_type: "ephemeral",
          text: """
          :octagonal_sign: `#{issue_number}` is not a valid issue number. Use this format instead `/poker issue 1234`.
          """
        }
    end
  end

  def execute_command(command, _channel) do
    %{
      type: "mrkdwn",
      response_type: "ephemeral",
      text: """
      Command `#{command}` is not available. Use `/poker help` to view list of available commands.
      """
    }
  end
end
