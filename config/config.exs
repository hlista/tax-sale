# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tax_sale,
  ecto_repos: [TaxSale.Repo],
  generators: [timestamp_type: :utc_datetime]

config :tax_sale, Oban,
  notifier: Oban.Notifiers.PG,
  engine: Oban.Engines.Lite,
  peer: Oban.Peers.Global,
  queues: [tax_search: 1],
  repo: TaxSale.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 300},
    {Oban.Plugins.Cron,
     crontab: [
       {"0 */4 * * *", TaxSale.SearchWorker, args: %{event: "enqueue_tax_record_ids"}}
     ]}
  ]

config :floki, :html_parser, Floki.HTMLParser.Html5ever

config :ecto_shorts,
  repo: TaxSale.Repo,
  error_module: EctoShorts.Actions.Error

# Configures the endpoint
config :tax_sale, TaxSaleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TaxSaleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TaxSale.PubSub,
  live_view: [signing_salt: "REWo9ncK"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :tax_sale, TaxSale.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
