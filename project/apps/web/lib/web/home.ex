defmodule UM.Web.Home do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:pieces]

  def handle_request(request = %{path: []}, _env) do
    Raxx.Response.ok(index_page_content([
      %{title: "hello", sub_heading: "sub heading", catalogue_number: "UD100", level_overview: "hello", notation_preview: %{url: "hi"}}
      ]))
  end

  instruments = [
    "piano",
    "recorder",
    "flute"
  ]
  for instrument <- instruments do
    def handle_request(_request = %{path: [unquote(instrument)]}, _env) do
      Raxx.Response.found("", [{"location", "/pieces?catalogue_search[#{unquote(instrument)}]=on"}])
    end
  end

  def handle_request(%{path: ["currency"], method: :POST, body: form}, _env) do
    currency = Map.get(form, "preference")
    currency = case currency do
      "USD" -> "USD"
      "EUR" -> "EUR"
      "GBP" -> "GBP"
      _ -> "GBP"
    end
    # TODO send to referer
    # set_cookie_string = Raxx.Cookie.new("um.currency_preference", currency)
    # |> Raxx.Cookie.set_cookie_string
    response = Raxx.Response.found("", [
      {"location", "/"},
      {"um-set-session", %{currency_preference: currency}}
    ])
    # {:ok, response} = Raxx.Patch.set_header(response, "set-cookie", set_cookie_string)
    response
  end

  def handle_request(_, _) do
    Raxx.Response.not_found("HOME not found")
    # TODO make this work
    # UM.Web.not_found()
  end
end
