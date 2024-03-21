import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :buzzword_bingo_live, Buzzword.Bingo.LiveWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WFt05LXbacV2UuqYAF7ofPkYova7RCd+7J23cNwBTa1aqxXuTbqyh4RwMAiv7mYe",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
