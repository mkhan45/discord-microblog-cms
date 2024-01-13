defmodule DiscordMicroblogApp.Content do
  use Agent

  defmodule Entry do
    defstruct [:content, :message_id]
  end

  defmodule Content do
    defstruct [:entries, :length, :message_id_to_entry]
  end

  def start_link(_) do
    Agent.start_link(fn -> %Content{entries: %{}, length: 0, message_id_to_entry: %{}} end, name: __MODULE__)
  end

  def add_content(content, message_id) do
    Agent.update(__MODULE__, fn contents ->
      length = contents.length + 1
      entries = Map.put(contents.entries, length, content)
      message_id_to_entry = Map.put(contents.message_id_to_entry, message_id, length)
      %Content{entries: entries, length: length, message_id_to_entry: message_id_to_entry}
    end)
  end

  def update_content(message_id, content) do
    Agent.update(__MODULE__, fn contents ->
      entry_id = contents.message_id_to_entry[message_id]
      entries = Map.put(contents.entries, entry_id, content)
      %Content{entries: entries, length: contents.length, message_id_to_entry: contents.message_id_to_entry}
    end)
  end

  def delete_content(message_id) do
    Agent.update(__MODULE__, fn contents ->
      entry_id = contents.message_id_to_entry[message_id]
      entries = Map.delete(contents.entries, entry_id)
      message_id_to_entry = Map.delete(contents.message_id_to_entry, message_id)
      %Content{entries: entries, length: contents.length, message_id_to_entry: message_id_to_entry}
    end)
  end

  def get_content() do
    Agent.get(__MODULE__, fn contents -> contents end)
  end
end
