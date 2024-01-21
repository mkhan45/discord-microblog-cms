defmodule DiscordMicroblogApp.BotConsumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias Nostrum.Struct.Guild.Member
  alias Nostrum.Struct.Message

  alias DiscordMicroblogApp.Content

  @self_id 178545593583403008

  def self_dms() do
    self_dms = Api.create_dm!(@self_id)
    channel_id = self_dms.id
    messages = Api.get_channel_messages!(channel_id, :infinity)
    %{messages: messages, channel_id: channel_id}
  end

  def handle_event({:READY, _ready, _}) do
    self_dms = Api.create_dm!(@self_id) |> IO.inspect
    channel_id = self_dms.id |> IO.inspect
    messages = Api.get_channel_messages!(channel_id, :infinity) |> IO.inspect
    for message <- Enum.reverse(messages), do: Content.add_content(message)
  end

  def handle_event({:MESSAGE_CREATE, msg, _}) do
    if msg.author.id == @self_id do
      Content.add_content(msg)
    end
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
