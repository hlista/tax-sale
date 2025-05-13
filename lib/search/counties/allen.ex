defmodule TaxSale.Search.Counties.Allen do
  require Logger
  alias PG.Context

  def search_and_update(tax_record_id) do
    with {:ok, tax_record} <- Context.find_tax_record(%{id: tax_record_id}) do
      Logger.info("Searching #{tax_record.parcel_number}")
      update_tax_record(tax_record)
    end
  end

  def update_tax_record(tax_record) do
    with {:ok, property_info} <- LowTaxInfo.fetch_property_info(tax_record.parcel_number, "ALN", tax_year()) do
      property_info = Map.put(property_info, :last_search, DateTime.utc_now())
      Context.update_tax_record(tax_record, property_info)
    end
  end

  defp tax_year, do: Application.get_env(:tax_sale, :tax_year)
end
