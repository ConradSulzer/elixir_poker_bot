defmodule Poker.PokerSession.PokerMessenger do
  @moduledoc """
  module for handling sending messages for poker session
  """

  alias Poker.Slack.{MessageBlocks, Slack}

  def message_channel(%{channel: channel}, message) do
    blocks = [MessageBlocks.text_section(message, "channel-message")]

    Slack.send_message(%{channel: channel, as_user: true, blocks: blocks})
  end

  def send_initial_card(%{channel: channel} = session) do
    blocks = [
      MessageBlocks.github_title_block(session),
      MessageBlocks.text_section("*Estimate Points*", "vote_section_header"),
      MessageBlocks.vote_options()
    ]

    Slack.send_message(%{channel: channel, as_user: true, blocks: blocks})
  end

  def send_new_vote(%{channel: channel, ts: ts} = session) do
    blocks = [
      MessageBlocks.github_title_block(session),
      MessageBlocks.text_section("*Estimate Points*", "vote_section_header"),
      MessageBlocks.vote_options(),
      MessageBlocks.votes(session),
      MessageBlocks.vote_count(session, :with_reveal)
    ]

    Slack.update_message(%{channel: channel, as_user: true, blocks: blocks, ts: ts})
  end

  def send_reveal(%{channel: channel, ts: ts, issue: issue} = session) do
    blocks = [
      MessageBlocks.github_title_block(session),
      MessageBlocks.revealed_votes(session),
      MessageBlocks.vote_count(session),
      MessageBlocks.text_section(
        "*Assigns Points to Issue ##{issue}*",
        "label_section_header"
      ),
      MessageBlocks.label_options(session)
    ]

    Slack.update_message(%{channel: channel, as_user: true, blocks: blocks, ts: ts})
  end

  def send_label_assigned(%{channel: channel, ts: ts} = session, points) do
    blocks = [
      MessageBlocks.github_title_block(session),
      MessageBlocks.revealed_votes(session),
      MessageBlocks.vote_count(session),
      MessageBlocks.text_section(
        "*Points Assigned: #{points}*",
        "label_section_header"
      )
    ]

    Slack.update_message(%{channel: channel, as_user: true, blocks: blocks, ts: ts})
  end
end
