defmodule UM.Web.Customers do
  alias UM.Web.Customers.CreateForm
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  order_history_file = String.replace_suffix(__ENV__.file, ".ex", "/order_history.html.eex")
  EEx.function_from_file :def, :order_history_content, order_history_file, [:customer]

  def handle_request(request = %{method: :GET, path: ["new"]}, _) do
    Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
  end

  def handle_request(request = %{path: [], method: post}, _env) do
    {:ok, form} = request.body |> Plug.Conn.Query.decode |> Map.fetch("customer")
    case CreateForm.validate(form) do
      {:error, {form, errors}} ->
        Raxx.Response.bad_request(new_page_content(form, errors, ""))
      {:ok, customer} ->
        customer = Map.drop(customer, [:password_confirmation, :terms_agreement])
        case UM.Accounts.signup_customer(customer) do
          # test is email taken
          {:error, reason} ->
            IO.inspect(reason)
            Raxx.Response.conflict(new_page_content(customer, %{email: "is already taken"}, ""))
          %{id: id} ->
            # TODO send an email
            Raxx.Response.see_other("", [{"location", "/customers/#{id}"}])
        end
    end
  end

  def handle_request(request = %{path: [id | rest]}, _) do
    authority = Raxx.Patch.get_header(request, "um-user-id")
    case has_permission?(authority, id) do
      true ->
        customer = UM.Accounts.fetch_customer(id)
        customer_endpoint(%{request | path: rest}, customer)
      false ->
        Raxx.Response.not_found("")
    end
  end

  def customer_endpoint(%{path: []}, customer) do
    Raxx.Response.ok("order_history_content(customer)")
  end

  def has_permission?(authority, id) do
    case {authority, id} do
      {id, id} -> true
      {"dummy-admin-id", _} -> true
      _ -> false
    end
  end
  def csrf_tag do
# TODO
  end
  def render(_) do
    "TODO"
  end
end
