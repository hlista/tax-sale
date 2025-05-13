defmodule TaxSale.Schemas.Queries.TaxRecord do
  use Absinthe.Schema.Notation
  alias TaxSale.Resolvers

  object :tax_record_queries do
    @desc """
    Query for all known tax records
    """
    field :tax_records, list_of(:tax_record) do
      arg :token, non_null(:string)
      resolve &Resolvers.TaxRecord.all/2
    end
  end
end
