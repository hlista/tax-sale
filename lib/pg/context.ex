defmodule PG.Context do
  alias EctoShorts.{
    Actions,
    CommonFilters
  }
  alias PG.Schemas.TaxRecord
  import Ecto.Query

  def tax_record_exists?(params \\ %{}) do
    TaxRecord
    |> CommonFilters.convert_params_to_filter(params)
    |> TaxSale.Repo.exists?()
  end

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

  def fetch_next_tax_record(current_id) do
    TaxRecord
    |> where([u], u.id > ^current_id)
    |> order_by(asc: :id)
    |> limit(1)
    |> select([u], u.id)
    |> TaxSale.Repo.one()
  end
end
