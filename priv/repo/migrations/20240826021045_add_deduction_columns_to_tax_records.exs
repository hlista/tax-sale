defmodule TaxSale.Repo.Migrations.AddDeductionColumnsToTaxRecords do
  use Ecto.Migration

  def change do
    alter table(:tax_records) do
      add :homestead_deduction, :decimal
      add :mortgage_deduction, :decimal
    end
  end
end
