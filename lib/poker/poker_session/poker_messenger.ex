defmodule Poker.PokerSession.PokerMessenger do
  @moduledoc """
  module for handling sending messages for poker session
  """

  alias Poker.Slack.{MessageBlocks, Slack}

  def send_initial_card(%{channel: channel} = session) do
    blocks = [
      MessageBlocks.github_title_block(session),
      MessageBlocks.vote_section_header(),
      MessageBlocks.vote_options()
    ]

    Slack.send_message(%{channel: channel, as_user: true, blocks: blocks})
  end
end
