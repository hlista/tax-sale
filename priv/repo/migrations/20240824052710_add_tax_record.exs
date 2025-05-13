defmodule TaxSale.Repo.Migrations.AddTaxRecord do
  use Ecto.Migration

  def change do
    create table(:tax_records) do
      add :parcel_number, :string
      add :tax_sale, :boolean
      add :last_search, :timestamp

      timestamps()
    end

    create unique_index(:tax_records, [:parcel_number])
  end
end
