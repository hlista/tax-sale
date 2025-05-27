defmodule TaxSale.Resolvers.TaxRecord do
  alias PG.Context
  @access_token "LARRY"
  def all(%{token: @access_token}, _) do
    {:ok, Context.all_tax_records()}
  end

  def all(_, _) do
    {:error, "Invalid Token"}
  end

  def add(%{parcel_numbers: parcel_numbers, token: @access_token}, _) do
    tax_records = Enum.reduce(parcel_numbers, [], fn parcel_number, acc ->
      case Context.tax_record_exists?(%{parcel_number: parcel_number}) do
        true ->
          acc
        false ->
          case Context.create_tax_record(%{parcel_number: parcel_number}) do
            {:ok, schema} ->
              [schema | acc]
            _ ->
              acc
          end
      end
    end)
    case List.last(tax_records) do
      nil ->
        {:ok, []}
      tax_record ->
        queue_oban_job(tax_record.id)
        {:ok, tax_records}
    end
  end

  def add(_, _) do
    {:error, "Invalid Token"}
  end

  defp queue_oban_job(tax_record_id) do
    %{
      event: "perform_search",
      id: tax_record_id,
      backfill: true
    }
    |> TaxSale.SearchWorker.new()
    |> Oban.insert()
  end

  def delete_all(%{token: @access_token}, _) do
    with {num, _} <- Context.delete_all_tax_records() do
      {:ok, num}
    end
  end

  def delete_all(_, _) do
    {:error, "Invalid Token"}
  end

  def backfill(%{token: @access_token, id: id}, _) do
    queue_oban_job(id)
    {:ok, 1}
  end

  def backfill(_, _) do
    {:ok, 0}
  end
end
