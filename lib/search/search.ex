defmodule TaxSale.Search do
  alias TaxSale.Search.Counties.{
    Allen,
    LaPorte,
    Lake,
    Porter,
    StJoseph
  }
  alias PG.Context
  def run(tax_record_id) do
    with {:ok, tax_record} <- Context.find_tax_record(%{id: tax_record_id}) do
      prefix = String.slice(tax_record.parcel_number, 0..1)
      case prefix do
        "71" ->
          StJoseph.search_and_update(tax_record_id)
        "46" ->
          LaPorte.search_and_update(tax_record_id)
        "64" ->
          Porter.search_and_update(tax_record_id)
        "45" ->
          Lake.search_and_update(tax_record_id)
        "02" ->
          Allen.search_and_update(tax_record_id)
        _ ->
          {:error, ErrorMessage.conflict("Unable to search for county")}
      end
    end
  end
end
