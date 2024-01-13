defmodule DiscordMicroblogTest do
  use ExUnit.Case
  doctest DiscordMicroblog

  test "greets the world" do
    assert DiscordMicroblog.hello() == :world
  end
end
