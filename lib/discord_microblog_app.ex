defmodule DiscordMicroblogApp.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.Message

  alias DiscordMicroblogApp.Content

  # def handle_event({:READY, ready, _}) do
  # end

  def handle_event({:MESSAGE_CREATE, msg, _}) do
    Content.add_content(msg.content, msg.id)
  end

  def handle_event({:MESSAGE_UPDATE, msg, _}) do
    Content.update_content(msg.id, msg.content)
  end

  def handle_event({:MESSAGE_DELETE, msg, _}) do
    Content.delete_content(msg.id)
  end
end

defmodule DiscordMicroblog.Application do
  use Application

  def start(_type, _args) do
    children = [DiscordMicroblogApp.BotConsumer, DiscordMicroblogApp.Content, DiscordMicroblogWeb.Endpoint]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
