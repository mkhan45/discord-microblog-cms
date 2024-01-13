defmodule DiscordMicroblog.Controller do
  use Phoenix.Controller

  def index(conn, _) do
    content = DiscordMicroblogApp.Content.get_content()
    content_ls = Enum.map(0..content.length, fn i -> content.entries[i] end) |> Enum.filter(fn x -> x != nil end)
    json(conn, content_ls)
  end
end

defmodule DiscordMicroblog.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiscordMicroblog do
    pipe_through :api

    get "/", Controller, :index
  end
end

defmodule DiscordMicroblogWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :discord_microblog
  plug DiscordMicroblog.Router
end
