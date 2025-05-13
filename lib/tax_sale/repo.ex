defmodule TaxSale.Repo do
  use Ecto.Repo,
    otp_app: :tax_sale,
    adapter: Ecto.Adapters.SQLite3
end
