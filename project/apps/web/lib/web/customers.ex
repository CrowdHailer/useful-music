defmodule UM.Web.Customers do
  alias UM.Web.Customers.CreateForm
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  def handle_request(request = %{method: :GET, path: ["new"]}, _) do
    Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
  end

  def handle_request(request = %{path: []}, _env) do
    {:ok, form} = request.body |> Plug.Conn.Query.decode |> Map.fetch("customer")
    {data, errors} = CreateForm.validate(form)
    |> IO.inspect
    # This is not good but will do for the moment. maybe always assume form has string keys.
    form = for {key, val} <- form, into: %{}, do: {String.to_atom(key), val}
    Raxx.Response.see_other(new_page_content(form, errors, ""))
  end
  defp create(data) do
    customer = data
    {:ok, customer}
  end

  def csrf_tag do
# TODO
  end
end
