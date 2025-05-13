defmodule TaxSale.Schema do
  use Absinthe.Schema
  alias TaxSale.Schemas.Queries
  alias TaxSale.Schemas.Mutations
  alias TaxSale.Types

  import_types Absinthe.Type.Custom
  import_types Types.TaxRecord
  import_types Queries.TaxRecord
  import_types Mutations.TaxRecord

  query do
    import_fields :tax_record_queries
  end

  mutation do
    import_fields :tax_record_mutations
  end
end
