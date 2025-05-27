defmodule TaxSale.SearchWorker do
  use Oban.Worker,
    queue: :tax_search,
    max_attempts: 1,
    unique: true
  alias PG.Context
  alias TaxSale.Search
  require Logger

  @backfill_delay 10

  @impl Oban.Worker
  def perform(%Oban.Job{
    args: %{
      "event" => "perform_search",
      "id" => tax_record_id,
      "backfill" => true
    }
  }) do
    case Context.fetch_next_tax_record(tax_record_id) do
      next_id when is_integer(next_id) ->
        %{id: next_id, backfill: true, event: "perform_search"}
        |> new(schedule_in: @backfill_delay)
        |> Oban.insert()

      nil ->
        :ok
    end
    with {:ok, _} <- Search.run(tax_record_id) do
      Logger.info("updated tax_record #{tax_record_id}")
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
    args: %{
      "event" => "perform_search",
      "id" => tax_record_id,
      "backfill" => false
    }
  }) do
    with {:ok, _} <- Search.run(tax_record_id) do
      Logger.info("updated tax_record #{tax_record_id}")
      :ok
    end
  end

  @impl Oban.Worker
  def perform(%Oban.Job{
    args: %{
      "event" => "start"
    }
  }) do
    case Context.fetch_next_tax_record(0) do
      next_id when is_integer(next_id) ->
        %{id: next_id, backfill: true, event: "perform_search"}
        |> new(schedule_in: @backfill_delay)
        |> Oban.insert()

      nil ->
        :ok
    end
  end
end
