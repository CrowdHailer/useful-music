defmodule UM.Web.Home do
  def handle_request(request = %{path: []}, _env) do
    Raxx.Response.ok()
  end

  instruments = [
    "piano",
    "recorder",
    "flute"
  ]
  for instrument <- instruments do
    def handle_request(request = %{path: [unquote(instrument)]}, _env) do
      Raxx.Response.found("", [{"location", "/pieces?catalogue_search[#{unquote(instrument)}]=on"}])
    end
  end

  def handle_request(request = %{path: ["currency"], method: :POST}, _env) do
    form = Plug.Conn.Query.decode(request.body)
    currency = Map.get(form, "preference")
    currency = case currency do
      "USD" -> "USD"
      "EUR" -> "EUR"
      "GBP" -> "GBP"
      _ -> "GBP"
    end
    # TODO send to referer
    set_cookie_string = Raxx.Cookie.new("um.currency_preference", currency)
    |> Raxx.Cookie.set_cookie_string
    response = Raxx.Response.found("", [{"location", "/"}])
    {:ok, response} = Raxx.Session.set_header(response, "set-cookie", set_cookie_string)
    response
  end

  def handle_request(_, _) do
    Raxx.Response.not_found()
    # TODO make this work
    # UM.Web.not_found()
  end
end
