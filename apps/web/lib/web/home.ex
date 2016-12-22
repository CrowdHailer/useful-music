defmodule UM.Web.Home do
  import UM.Web.ViewHelpers
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, [:pieces]

  def handle_request(request = %{path: [], method: :GET}, _env) do
    {:ok, pieces} = UM.Catalogue.random_pieces(4)
    Raxx.Response.ok(index_page_content(pieces))
  end

  for tag <- UM.Catalogue.tags do
    tag = "#{tag}"
    def handle_request(_request = %{path: [unquote(tag)], method: :GET}, _env) do
      Raxx.Patch.redirect("/pieces?catalogue_search[#{unquote(tag)}]=on")
    end
  end

  def handle_request(%{path: ["woodwind"], method: :GET}, _) do
    Raxx.Patch.redirect({"/pieces", %{
      catalogue_search: %{
        recorder: "on",
        flute: "on",
        oboe: "on",
        clarineo: "on",
        clarinet: "on",
        bassoon: "on",
        saxophone: "on"
      }
    }})
  end

  def handle_request(request = %{path: ["currency"], method: :POST, body: form}, _env) do
    currency = Map.get(form, "preference")
    currency = case currency do
      "USD" -> "USD"
      "EUR" -> "EUR"
      "GBP" -> "GBP"
      _ -> "GBP"
    end

    referrer = Raxx.Patch.referrer(request) || "/"
    {session, request} = UM.Web.Session.from_request(request)
    session = case UM.Web.Session.current_customer(session) do
      :guest ->
        %{session | currency_preference: currency}
      customer ->
        {:ok, customer} = UM.Accounts.update_customer(%{id: customer.id, currency_preference: currency})
        %{session | currency_preference: currency, customer: customer}
    end
    response = Raxx.Patch.redirect(referrer)
    {:ok, response} = Raxx.Patch.set_header(response, "um-set-session", session)
    response
  end

  def handle_request(%{path: ["favicon.ico"], method: :GET}, _) do
    Raxx.Response.not_found
  end
end
