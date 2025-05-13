defmodule TaxSaleWeb.Router do
  use TaxSaleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
  scope "/" do
    pipe_through [:api]

    forward "/api", Absinthe.Plug, schema: TaxSale.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: TaxSale.Schema,
      interface: :advanced
  end
end
