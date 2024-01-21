defmodule DiscordMicroblog.Controller do
  use Phoenix.Controller

  def index(conn, _) do
    content = DiscordMicroblogApp.Content.get_content()
    content_ls = Enum.map((content.length-1)..0//-1, fn i -> content.entries[i] end) |> Enum.filter(fn x -> x != nil end)
    json(conn, %{updates: content_ls})
  end
end

defmodule DiscordMicroblog.Router do
  use Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
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

defmodule DiscordMicroblogWeb.ErrorView do
  def render(template, assigns) do
    IO.puts(template)
    IO.puts(assigns)
    IO.puts(assigns.reason.description)
    Phoenix.Controller.status_message_from_template(template)
  end
end
