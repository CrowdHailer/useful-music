defmodule UM.Web.SessionsController do
  # alias UM.Web.Customers.CreateForm

  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]

  def handle_request(_request = %{path: ["new"], query: query, method: :GET}, _) do
    target = Map.get(query, "target", "")
    Raxx.Response.ok(new_page_content(target))
  end

  def handle_request(request, _env) do
    {:ok, form} = Raxx.Request.content(request)
    target = Map.get(form, "target")
    form = Utils.sub_form(form, "session")
    case {:ok, %{email: form["email"], password: form["password"]}} do
      {:ok, data} ->
        case UM.Accounts.authenticate(data) do
          {:ok, customer} ->
            response = Raxx.Response.see_other("", [{"location", target || "/customers/#{customer.id}"}])
            Raxx.Session.Open.overwrite(customer.id, response)
        end
    end
  end

  # def handle_request(message, state) do
  #   # state includes config and session
  #   {state, [{client: response}]}
  # end

  defp csrf_tag do
    "TODO"
  end
end
