defmodule PG.Context do
  alias EctoShorts.Actions
  alias PG.Schemas.TaxRecord

  def all_tax_records(params \\ %{}) do
    Actions.all(TaxRecord, params)
  end

  def find_tax_record(params \\ %{}) do
    Actions.find(TaxRecord, params)
  end

  def create_tax_record(params) do
    Actions.create(TaxRecord, params)
  end

  def find_or_create_tax_record(params) do
    Actions.find_or_create(TaxRecord, params)
  end

  def find_and_update_or_create_tax_record(find_params, update_params) do
    Actions.find_and_upsert(TaxRecord, find_params, update_params)
  end

  def update_tax_record(id, params) do
    Actions.update(TaxRecord, id, params)
  end

  def delete_all_tax_records() do
    TaxSale.Repo.delete_all(TaxRecord)
  end
end
