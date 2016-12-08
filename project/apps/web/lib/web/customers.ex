defmodule UM.Web.Customers do
  alias UM.Web.Customers.{CreateForm, EditForm}
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  order_history_file = String.replace_suffix(__ENV__.file, ".ex", "/order_history.html.eex")
  EEx.function_from_file :def, :order_history_content, order_history_file, [:customer]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:form, :errors, :success_path]

  # TODO redirect if logged in
  def handle_request(%{method: :GET, path: ["new"]}, _) do
    Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
  end

  # TODO redirect if logged in
  def handle_request(request = %{path: [], method: :POST, body: %{"customer" => form}}, _env) do
    session = UM.Web.Session.get(request)
    case CreateForm.validate(form) do
      {:error, {form, errors}} ->
        Raxx.Response.bad_request(new_page_content(form, errors, ""))
      {:ok, customer} ->
        customer = Map.drop(customer, [:password_confirmation, :terms_agreement])
        customer = Map.merge(customer, %{currency_preference: UM.Web.Session.currency_preference(session)})
        case UM.Accounts.signup_customer(customer) do
          # test is email taken
          {:error, reason} ->
            IO.inspect(reason)
            Raxx.Response.conflict(new_page_content(customer, %{email: "is already taken"}, ""))
          %{id: id} ->
            # TODO send an email
            success_message = "Welcome to Useful Music"
            Raxx.Patch.redirect("/customers/#{id}", success: success_message)
        end
    end
  end

  # function login(session, customer) -> updated session

  def handle_request(request = %{path: [id | rest]}, _) do
    session = UM.Web.Session.get(request)
    case UM.Web.Session.can_view_customer?(session, id) do
      true ->
        customer = UM.Accounts.fetch_customer(id)
        customer_endpoint(%{request | path: rest}, customer)
      false ->
        Raxx.Response.not_found("Don't look here")
    end
  end

  def customer_endpoint(%{path: [], method: :GET}, _customer) do
    Raxx.Response.ok("order_history_content(customer)")
  end

  def customer_endpoint(%{path: ["edit"], method: :GET}, customer) do
    Raxx.Response.ok(edit_page_content(customer, %EditForm{}, ""))
  end

  def customer_endpoint(%{path: [], method: :PUT, body: %{"customer" => form}}, customer) do
    case EditForm.validate(form) do
      {:ok, update} ->
        # Could merge with whole customer
        case UM.Accounts.update_customer(Map.merge(update, %{id: customer.id})) do
          {:ok, customer} ->
            Raxx.Patch.redirect("/customers/#{customer.id}", success: "Update successful")
        end
      {:error, {form, errors}} ->
        customer = Map.merge(form, %{id: customer.id})
        Raxx.Response.bad_request(edit_page_content(customer, errors, ""))
    end
  end

  def csrf_tag do
# TODO
  end
  def render(_) do
    "TODO"
  end
  def all_countries do
    [{"Great Britian", "GB"}]
  end
end
