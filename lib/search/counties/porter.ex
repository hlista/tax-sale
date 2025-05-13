defmodule TaxSale.Search.Counties.Porter do
  require Logger
  alias PG.Context
  @low_tax_info_parcel_number_url "https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=POR&parcel=PARCEL_NUMBER&page_number=0"
  @low_tax_info_dup_url "https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/GetParcel?CorpCode=POR&dup=DUP_NUMBER&PayYear=2024"
  def search_and_update(tax_record_id) do
    with {:ok, tax_record} <- Context.find_tax_record(%{id: tax_record_id}) do
      Logger.info("Searching #{tax_record.parcel_number}")
      update_tax_record(tax_record)
    end
  end

  def update_tax_record(tax_record) do
    update_params = tax_record.parcel_number
    |> fetch_property_info()
    |> Map.put(:last_search, DateTime.utc_now())
    Context.update_tax_record(tax_record, update_params)
  end

  def fetch_property_info(parcel_number) do
    dup_number = fetch_dup_number(parcel_number)
    results = fetch_property_json(dup_number)
    results
    |> get_tax_sale_status()
    |> Map.merge(get_accessed_value(results))
    |> Map.merge(get_homestead_deduction(results))
    |> Map.merge(get_name_and_address(results))
  end

  def get_tax_sale_status(results) do
    tax_sale = results["propertyInfo"]["TaxSaleSold"]
    if tax_sale === "T" do
      %{
        tax_sale: true
      }
    else
      %{
        tax_sale: false
      }
    end
  end

  def get_accessed_value(results) do
    gross_accessed_value_of_property = results
    |> Map.get("assessedValues")
    |> Enum.reduce(0, fn map, acc ->
      acc + map["Amount"]
    end)
    %{
      gross_accessed_value_of_property: gross_accessed_value_of_property
    }
  end

  def get_homestead_deduction(results) do
    homestead_deduction = results
    |> Map.get("exemptionsDeductions")
    |> Enum.find(& &1["DESCRIPTION"] === "Std Hmstd Deduct")
    |> Map.get("AMOUNT")
    %{
      homestead_deduction: homestead_deduction
    }
  end

  def get_name_and_address(results) do
    name = results["propertyInfo"]["OwnerName"]
    mailing_address1 = results["propertyInfo"]["MAILINGADDRESS1"]
    mailing_address2 = results["propertyInfo"]["MAILINGADDRESS1"]
    mailing_city = results["propertyInfo"]["MAILINGCITY"]
    mailing_state = results["propertyInfo"]["MAILINGSTATE"]
    mailing_zip = results["propertyInfo"]["MAILINGZIPCODE"]
    property_address1 = results["propertyInfo"]["PROPERTYADDRESS1"]
    property_address2 = results["propertyInfo"]["PROPERTYADDRESS2"]
    property_city = results["propertyInfo"]["PROPERTYCITY"]
    property_state = results["propertyInfo"]["PROPERTYSTATE"]
    property_zip = results["propertyInfo"]["PROPERTYZIPCODE"]
    mailing_address_full = "#{name} #{mailing_address1} #{mailing_address2} #{mailing_city} #{mailing_state} #{mailing_zip}"
    property_address_full = "#{property_address1} #{property_address2} #{property_city} #{property_state} #{property_zip}"
    %{
      name_and_address: mailing_address_full,
      location: property_address_full
    }
  end

  def fetch_dup_number(parcel_number) do
    url = String.replace(@low_tax_info_parcel_number_url, "PARCEL_NUMBER", parcel_number)
    with {:ok, %{body: %{"Results" => [_, map]}}} <- Req.get(url) do
      map["DuplicateNumber"]
    end
  end

  def fetch_property_json(dup_number) do
    url = String.replace(@low_tax_info_dup_url, "DUP_NUMBER", "#{dup_number}")
    with {:ok, %{body: body}} <- Req.get(url) do
      body
    end
  end
end
