defmodule UM.Web.SessionsController do
  # alias UM.Web.Customers.CreateForm
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:target]


  def handle_request(request = %{path: ["new"], query: query, method: :GET}, _) do
    target = Map.get(query, "target", "")
    Raxx.Response.ok(new_page_content(target))
  end

  defp csrf_tag do
    "TODO"
  end
end
