defmodule TaxSale.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TaxSaleWeb.Telemetry,
      TaxSale.Repo,
      {DNSCluster, query: Application.get_env(:tax_sale, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TaxSale.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TaxSale.Finch},
      # Start a worker by calling: TaxSale.Worker.start_link(arg)
      # {TaxSale.Worker, arg},
      # Start to serve requests, typically the last entry
      TaxSaleWeb.Endpoint,
      {Oban, Application.fetch_env!(:tax_sale, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaxSale.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaxSaleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
