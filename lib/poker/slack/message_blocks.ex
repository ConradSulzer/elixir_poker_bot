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

  def text_section(text, block_id) do
    %{
      type: "section",
      block_id: block_id,
      text: %{
        type: "mrkdwn",
        text: text
      }
    }
  end

  def vote_options() do
    %{
      type: "actions",
      block_id: "vote_section",
      elements: buttons_from_list([1, 2, 3, 5, 8, 13], "vote", "danger")
    }
  end

  def votes(%{voters: voters}) do
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

  def vote_count(%{voters: voters}) do
    %{
      type: "section",
      text: %{
        type: "mrkdwn",
        text: "Votes: #{Enum.count(voters)}"
      }
    }
  end

  def vote_count(session, :with_reveal) do
    reveal_button = %{
      accessory: %{
        type: "button",
        action_id: "reveal",
        text: %{
          type: "plain_text",
          text: "Reveal Votes"
        },
        style: "primary",
        value: "reveal"
      }
    }

    Map.merge(vote_count(session), reveal_button)
  end

  def revealed_votes(%{voters: voters}) do
    vote_emojis = %{
      "1" => ":one:",
      "2" => ":two:",
      "3" => ":three:",
      "5" => ":five:",
      "8" => ":eight:",
      "13" => ":one::three:"
    }

    voter_string =
      voters
      |> Enum.map(&"#{vote_emojis[elem(&1, 1)]} <@#{elem(&1, 0)}>")
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

  def label_options(%{voters: voters}) do
    values =
      voters
      |> Enum.uniq_by(fn {_k, v} -> v end)
      |> Enum.map(&elem(&1, 1))

    %{
      type: "actions",
      block_id: "vote_section",
      elements: buttons_from_list(values, "label", "primary")
    }
  end

  defp buttons_from_list(list, action, color) do
    Enum.map(list, fn val ->
      %{
        type: "button",
        action_id: "#{action} #{val}",
        text: %{
          type: "plain_text",
          text: "#{val}"
        },
        value: "#{val}",
        style: color
      }
    end)
  end
end
