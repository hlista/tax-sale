defmodule TaxSale.Search.Counties.Lake do
  require Logger
  alias PG.Context
  import Meeseeks.XPath

  @request_verification_token_xpath "//*[@id=\"Form\"]/input[3]"
  @tax_sale_url "https://in-lake.publicaccessnow.com/API/PaymentBill/Bill/GetData"
  @quick_search_url "https://in-lake.publicaccessnow.com/DesktopModules/QuickSearch/API/Module/GetData"

  def search_and_update(tax_record_id) do
    with {:ok, tax_record} <- Context.find_tax_record(%{id: tax_record_id}) do
      Logger.info("Searching #{tax_record.parcel_number}")
      updates = search(tax_record.parcel_number)
      Context.update_tax_record(tax_record_id, updates)
    end
  end

  def search(parcel_number) do
    with {:ok, %{cookie: cookie, verification_token: verification_token}}
          <- get_request_cookie_and_token(parcel_number) do
      Logger.info("Searching #{parcel_number}")
      tax_sale?(parcel_number, cookie, verification_token)
      |> Map.merge(property_info(parcel_number, cookie, verification_token))
      |> Map.put(:last_search, DateTime.utc_now())
    end
  end

  def tax_sale?(parcel_number, cookie, verification_token) do
    {_, %{body: body}} = request(@tax_sale_url, cookie, verification_token, "636", parcel_number)
    %{
      tax_sale: String.contains?(body, "Please contact the Treasurer's Office")
    }
  end

  def property_info(parcel_number, cookie, verification_token) do
    {_, %{body: body}} =
      quick_search_request(@quick_search_url, cookie, verification_token, "647", parcel_number)
    json = Jason.decode!(body)
    fields = List.first(json["items"])["fields"]
    get_name_and_address(fields)
    %{
      name_and_address: get_name_and_address(fields),
      location: fields["Situs"]
    }
  end

  defp get_name_and_address(%{"Owner" => owner, "MailAddress" => mail_address, "MailCityStateZip" => mail_city_state_zip}) do
    "#{String.trim(owner)} #{String.trim(mail_address)} #{String.trim(mail_city_state_zip)}"
  end

  defp get_name_and_address(_) do
    nil
  end

  def get_request_cookie_and_token(pid) do
    minified_pid = String.replace(pid, [".", "-"], "")
    {:ok, %{body: body, headers: %{"set-cookie" => cookies}}} = Req.get("https://in-lake.publicaccessnow.com/PropertyTax/TaxSearch/Account.aspx?p=#{minified_pid}&a=#{pid}")
    {"input",
         [
           {"name", "__RequestVerificationToken"},
           {"type", "hidden"},
           {"value",
            verification_token}
         ], []} = body
    |> Meeseeks.one(xpath(@request_verification_token_xpath))
    |> Meeseeks.tree()
    {:ok, %{cookie: cookies, verification_token: verification_token}}
  end

  def request(url, cookie, verification_token, module_id, pid) do
    minified_pid = String.replace(pid, [".", "-"], "")
    #{:ok, %{cookie: cookie, verification_token: verification_token}} = get_request_cookie_and_token()
    Req.Request.new(
      method: :get,
      url: "#{url}?p=#{minified_pid}&a=#{pid}&_m=#{module_id}"
    )
    |> Req.Request.put_new_header("cookie", cookie)
    |> Req.Request.put_new_header("RequestVerificationToken", verification_token)
    |> Req.Request.put_new_header("Tabid", "49")
    |> Req.Request.put_new_header("moduleid", "#{module_id}")
    |> Req.Request.put_new_header("Cache-Control", "no-cache")
    |> Req.Request.put_new_header("Pragma", "no-cache")
    |> Req.Request.run_request()
  end

  def quick_search_request(url, cookie, verification_token, module_id, pid) do
    Req.Request.new(
      method: :get,
      url: "#{url}?keywords=#{pid}&page=1&_m=#{module_id}"
    )
    |> Req.Request.put_new_header("cookie", cookie)
    |> Req.Request.put_new_header("RequestVerificationToken", verification_token)
    |> Req.Request.put_new_header("Tabid", "111")
    |> Req.Request.put_new_header("moduleid", "#{module_id}")
    |> Req.Request.put_new_header("Cache-Control", "no-cache")
    |> Req.Request.put_new_header("Pragma", "no-cache")
    |> Req.Request.run_request()
  end

end
