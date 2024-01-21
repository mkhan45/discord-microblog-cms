defmodule DiscordMicroblogApp.Content do
  use Agent

  require Protocol

  # TODO: add attachment type
  Protocol.derive(Jason.Encoder, Nostrum.Struct.Message.Attachment, only: [:url])

  defmodule Entry do
    @derive [Jason.Encoder]
    defstruct [:content, :message_id, :attachments, :timestamp]
  end

  defmodule Content do
    @derive [Jason.Encoder]
    defstruct [:entries, :length, :message_indices]
  end

  def start_link(_) do
    Agent.start_link(fn -> %Content{entries: %{}, length: 0, message_indices: %{}} end, name: __MODULE__)
  end

  def clear() do
    Agent.update(__MODULE__, fn _ -> %Content{entries: %{}, length: 0, message_indices: %{}} end)
  end

  def add_content(message) do
    Agent.update(__MODULE__, fn contents ->
      entry = %Entry{
        content: message.content, 
        message_id: message.id, 
        attachments: message.attachments,
        timestamp: message.timestamp |> Calendar.strftime("%Y-%m-%d %H:%M:%S UTC")
      }
      idx = contents.length
      new_len = contents.length + 1
      %Content{
        entries: Map.put(contents.entries, idx, entry),
        length: new_len,
        message_indices: Map.put(contents.message_indices, message.id, idx),
      }
    end)
  end

  def update_content(message_id, content) do
    Agent.update(__MODULE__, fn contents ->
      entry_index = contents.message_indices[message_id]
      old_entry = contents.entries[entry_index]
      new_entry = %Entry{old_entry | content: content, message_id: message_id}
      %Content{contents | entries: Map.put(contents.entries, entry_index, new_entry)}
    end)
  end

  def delete_content(message_id) do
    # TODO: doesn't work
    Agent.update(__MODULE__, fn contents ->
      entry_idx = contents.message_indices[message_id]
      new_entries = 
        Enum.reduce(entry_idx+1..contents.length-1, contents.entries, fn idx, acc ->
          Map.put(acc, idx-1, contents.entries[idx])
        end)

      # probably could just skip this and leave holes
      message_indices = 
        Enum.reduce(entry_idx+1..contents.length-1, contents.message_indices, fn idx, acc ->
          IO.inspect(contents.entries[idx])
          IO.inspect(acc)
          if contents.entries[idx] != nil do
            Map.put(acc, contents.entries[idx].message_id, idx-1)
          else
            acc
          end
        end)

      %Content{
        entries: new_entries,
        length: contents.length - 1,
        message_indices: Map.delete(message_indices, message_id),
      }
    end)
  end

  def get_content() do
    Agent.get(__MODULE__, fn contents -> contents end)
  end
end
