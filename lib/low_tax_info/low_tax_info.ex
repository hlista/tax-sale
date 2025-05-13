defmodule LowTaxInfo do
  def fetch_dup_number(parcel_number, corp_code) do
    url = "https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=#{corp_code}&parcel=#{parcel_number}&page_number=0"
    with {:ok, %{body: %{"Results" => [_, map]}}} <- Req.get(url) do
      {:ok, map["DuplicateNumber"]}
    end
  end

  def fetch_property_json(dup_number, corp_code, pay_year) do
    url = "https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/GetParcel?CorpCode=#{corp_code}&dup=#{dup_number}&PayYear=#{pay_year}"
    with {:ok, %{body: body}} <- Req.get(url) do
      {:ok, body}
    end
  end

  def fetch_property_info(parcel_number, corp_code, pay_year) do
    with {:ok, dup_number} <- fetch_dup_number(parcel_number, corp_code),
         {:ok, property_json} <- fetch_property_json(dup_number, corp_code, pay_year) do
      property_json
      |> get_tax_sale_status()
      |> Map.merge(get_accessed_value(property_json))
      |> Map.merge(get_homestead_deduction(property_json))
      |> Map.merge(get_name_and_address(property_json))
      |> then(& {:ok, &1})
    end
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
    case results
    |> Map.get("exemptionsDeductions")
    |> Enum.find(& &1["DESCRIPTION"] === "Std Hmstd Deduct") do
      nil ->
        %{
          homestead_deduction: nil
        }
      map ->
        %{
          homestead_deduction: Map.get(map, "AMOUNT")
        }
    end
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
end
