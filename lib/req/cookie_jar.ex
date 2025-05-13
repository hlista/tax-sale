defmodule Req.CookieJar do
  use Agent

  def new() do
    Agent.start_link(fn -> "" end, name: __MODULE__)
  end

  defp get_cookie do
    Agent.get(__MODULE__, & &1)
  end

  defp set_cookie([]), do: nil
  defp set_cookie(val) do
    Agent.update(__MODULE__, fn (_) -> val end)
  end

  def attach(%Req.Request{} = request) do
    request
    |> Req.Request.append_response_steps(
      cookie_jar: fn({req, res})->
        Req.Response.get_header(res, "set-cookie")
        |> set_cookie()

        {req,res}
      end
    )
    |> Req.Request.append_request_steps(
      cookie_jar: &Req.Request.put_header(&1, "cookie", get_cookie())
    )
  end
end
