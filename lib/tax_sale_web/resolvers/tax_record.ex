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
    Enum.reduce(parcel_numbers, [], fn parcel_number, acc ->
      case Context.find_or_create_tax_record(%{parcel_number: parcel_number}) do
        {:ok, schema} ->
          queue_oban_job(schema)
          [schema | acc]
        _ ->
          acc
      end
    end)
    |> then(&({:ok, &1}))
  end

  def add(_, _) do
    {:error, "Invalid Token"}
  end

  defp queue_oban_job(tax_record) do
    %{
      event: "perform_search",
      tax_record_id: tax_record.id
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
end
