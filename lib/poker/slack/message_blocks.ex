defmodule Poker.Slack.MessageBlocks do
  @moduledoc """
  module for building message blocks
  """

  def github_title_block(%{title: title, issue_link: link, issue: issue}) do
    %{
      type: "section",
      block_id: "github_title",
      text: %{
        type: "mrkdwn",
        text: """
          *Issue Up For Estimating:*
          *<#{link}|#{issue} - #{title}>*
        """
      }
    }
  end

  def vote_section_header() do
    %{
      type: "section",
      block_id: "vote_section_header",
      text: %{
        type: "mrkdwn",
        text: """
          *Estimate Points*
        """
      }
    }
  end

  def vote_options() do
    values = [1, 2, 3, 5, 8, 13]

    elements =
      Enum.map(values, fn val ->
        %{
          type: "button",
          action_id: "vote #{val}",
          text: %{
            type: "plain_text",
            text: "#{val}"
          },
          value: "#{val}"
        }
      end)

    %{
      type: "actions",
      block_id: "vote_section",
      elements: elements
    }
  end

  def votes(voters) do
    voter_string =
      voters
      |> Enum.map(&":white_check_mark: <@#{elem(&1, 0)}>")
      |> Enum.join(" ")

    %{
      type: "section",
      block_id: "voter_list",
      text: %{
        type: "mrkdwn",
        text: voter_string
      }
    }
  end
end
