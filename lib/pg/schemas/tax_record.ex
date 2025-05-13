defmodule PG.Schemas.TaxRecord do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @parcel_number_regex ~r/\d*-\d*-\d*-\d*-\d*\.\d*-\d*/

  @required_fields [:parcel_number]

  @allowed_fields @required_fields ++ [
    :tax_sale,
    :last_search,
    :location,
    :name_and_address,
    :gross_accessed_value_of_property,
    :homestead_deduction,
    :mortgage_deduction
  ]

  schema "tax_records" do
    field :parcel_number, :string
    field :tax_sale, :boolean
    field :last_search, :utc_datetime
    field :location, :string
    field :name_and_address, :string
    field :gross_accessed_value_of_property, :decimal
    field :homestead_deduction, :decimal
    field :mortgage_deduction, :decimal

    timestamps(type: :utc_datetime)
  end

  def changeset(tax_record_form, attrs) do
    tax_record_form
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_parcel_number()
  end

  def create_changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  defp validate_parcel_number(changeset) do
    validate_format(changeset, :parcel_number, @parcel_number_regex,
      message: "invalid parcel number format"
    )
  end
end
