defmodule TaxSale.Schemas.Mutations.TaxRecord do
  use Absinthe.Schema.Notation
  alias TaxSale.Resolvers

  object :tax_record_mutations do
    field :add_tax_records, list_of(:tax_record) do
      arg :parcel_numbers, non_null(list_of(:string))
      arg :token, non_null(:string)
      resolve &Resolvers.TaxRecord.add/2
    end

    field :backfill_oban, :integer do
      arg :id, non_null(:id)
      arg :token, non_null(:string)
      resolve &Resolvers.TaxRecord.backfill/2
    end

    field :delete_all_tax_records, :integer do
      arg :token, non_null(:string)
      resolve &Resolvers.TaxRecord.delete_all/2
    end
  end
end
