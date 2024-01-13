import Config

config :nostrum,
  token: File.read!("config/token.secret") |> String.trim(),
  gateway_intents: :all

config :phoenix, :json_library, Jason

config :discord_microblog, DiscordMicroblogWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  server: true,
  secret_key_base: String.duplicate("a", 64)
