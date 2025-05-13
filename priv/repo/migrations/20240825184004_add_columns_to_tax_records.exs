defmodule TaxSale.Repo.Migrations.AddColumnsToTaxRecords do
  use Ecto.Migration

  def change do
    alter table(:tax_records) do
      add :location, :text
      add :name_and_address, :text
      add :gross_accessed_value_of_property, :decimal
    end
  end
end
