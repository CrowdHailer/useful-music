defmodule UM.Web.CustomersControllerController do
  import UM.Web.ViewHelpers
  alias UM.Web.CustomersController.{CreateForm, EditForm, ChangePasswordForm}
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  order_history_file = String.replace_suffix(__ENV__.file, ".ex", "/order_history.html.eex")
  EEx.function_from_file :def, :order_history_content, order_history_file, [:customer]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:form, :errors, :success_path]

  change_password_file = String.replace_suffix(__ENV__.file, ".ex", "/change_password.html.eex")
  EEx.function_from_file :def, :change_password_page_content, change_password_file, [:customer]

  account_sidebar_template = String.replace_suffix(__ENV__.file, ".ex", "/account_sidebar.html.eex")
  EEx.function_from_file :def, :render_account_sidebar, account_sidebar_template, [:customer]

  def handle_request(request = %{method: :GET, path: ["new"]}, _) do
    {session, request} = UM.Web.Session.from_request(request)
    case UM.Web.Session.guest_session?(session) do
      true ->
        Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
      false ->
        Raxx.Patch.redirect("/", success: "Already logged in")
    end
  end

  def handle_request(request = %{path: [], method: :POST, body: %{"customer" => form}}, _env) do
    {session, request} = UM.Web.Session.from_request(request)
    case UM.Web.Session.guest_session?(session) do
      true ->
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
              customer = %{id: id} ->
                Raxx.Patch.redirect("/customers/#{id}")
                |> UM.Web.with_flash(success: "Welcome to Useful Music")
                |> UM.Web.with_session(UM.Web.Session.login(session, customer))
            end
        end
      false ->
        Raxx.Patch.redirect("/", success: "Already logged in")
    end
  end

  # function login(session, customer) -> updated session

  def handle_request(request = %{path: [id | rest]}, _) do
    {session, request} = UM.Web.Session.from_request(request)
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

  def customer_endpoint(%{path: ["change_password"], method: :GET}, customer) do
    Raxx.Response.ok(change_password_page_content(customer))
  end

  def customer_endpoint(%{path: ["change_password"], method: :PUT, body: %{"customer" => form}}, customer) do
    case ChangePasswordForm.validate(form) do
      {:ok, data} ->
        # Could merge with whole customer
        case data.current_password == customer.password do
          true ->
            update = %{password: data.password}
            case UM.Accounts.update_customer(Map.merge(update, %{id: customer.id})) do
              {:ok, customer} ->
                Raxx.Patch.redirect("/customers/#{customer.id}", success: "Password changed")
            end
        end
      {:error, {form, errors}} ->
        customer = Map.merge(form, %{id: customer.id})
        Raxx.Response.bad_request(edit_page_content(customer, errors, ""))
    end
  end
end
