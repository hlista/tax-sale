import Config

config :tax_sale, TaxSale.Repo,
  database: Path.expand("../tax_sale_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

config :tax_sale, Oban, testing: :inline
# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tax_sale, TaxSaleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "r9Ua8LF3ZySbQVbQUD5Mx/68UVgny37EK/Jj74RMmrs0qxa6gVjPgQMLGyIzUuQr",
  server: false

# In test we don't send emails
config :tax_sale, TaxSale.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
