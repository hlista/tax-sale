defmodule TaxSale.SearchWorker do
  use Oban.Worker,
    queue: :tax_search,
    max_attempts: 3,
    unique: true
  alias PG.Context
  alias TaxSale.Search

  @impl Oban.Worker
  def perform(%Oban.Job{
    args: %{
      "event" => "enqueue_tax_record_ids"
    }
  }) do
    Context.all_tax_records()
    |> Enum.filter(fn %{tax_sale: tax_sale} ->
      tax_sale === nil or tax_sale === true
    end)
    |> Enum.with_index(1)
    |> Enum.each(fn {tax_record, index} ->
      %{
        event: "perform_search",
        tax_record_id: tax_record.id
      }
      |> __MODULE__.new(schedule_in: 10 * index)
      |> Oban.insert()
    end)
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
    args: %{
      "event" => "perform_search",
      "tax_record_id" => tax_record_id
    }
  }) do
    Search.run(tax_record_id)
  end
end
