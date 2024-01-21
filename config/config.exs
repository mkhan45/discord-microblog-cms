import Config

config :nostrum,
  token: File.read!("config/token.secret") |> String.trim(),
  gateway_intents: :all

config :phoenix, :json_library, Jason

config :discord_microblog, DiscordMicroblogWeb.Endpoint,
  http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: 4001],
  server: true,
  secret_key_base: String.duplicate("a", 64)
