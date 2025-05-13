defmodule TaxSale.Types.TaxRecord do
  use Absinthe.Schema.Notation

  object :tax_record do
    field :id, :id
    field :parcel_number, :string
    field :tax_sale, :boolean
    field :location, :string
    field :name_and_address, :string
    field :gross_accessed_value_of_property, :decimal
    field :homestead_deduction, :decimal
    field :mortgage_deduction, :decimal
    field :last_search, :datetime
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end
end
