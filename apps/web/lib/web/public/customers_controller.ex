defmodule UM.Web.CustomersControllerController do
  import UM.Web.ViewHelpers
  alias UM.Web.CustomersController.{CreateForm, EditForm, ChangePasswordForm}
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  order_history_file = String.replace_suffix(__ENV__.file, ".ex", "/order_history.html.eex")
  EEx.function_from_file :def, :order_history_content, order_history_file, [:orders, :customer]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:form, :errors, :success_path]

  change_password_file = String.replace_suffix(__ENV__.file, ".ex", "/change_password.html.eex")
  EEx.function_from_file :def, :change_password_page_content, change_password_file, [:customer]

  account_sidebar_template = String.replace_suffix(__ENV__.file, ".ex", "/account_sidebar.html.eex")
  EEx.function_from_file :def, :render_account_sidebar, account_sidebar_template, [:customer]

  def handle_request(request = %{method: :GET, path: ["new"]}, _) do
    session = UM.Web.fetch_session(request)
    if UM.Web.Session.logged_in?(session) do
      Raxx.Patch.redirect("/", success: "Already logged in")
    else
      Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
    end
  end

  def handle_request(request = %{path: [], method: :POST, body: %{"customer" => form}}, _env) do
    session = UM.Web.fetch_session(request)
    case UM.Web.Session.logged_in?(session) do
      false ->
        case CreateForm.validate(form) do
          {:error, {form, errors}} ->
            Raxx.Response.bad_request(new_page_content(form, errors, ""))
          {:ok, customer} ->
            customer = Map.drop(customer, [:password_confirmation, :terms_agreement])
            customer = Map.merge(customer, %{currency_preference: UM.Web.Session.currency_preference(session)})
            case UM.Accounts.signup_customer(customer) do
              {:error, reason} ->
                IO.inspect(reason)
                Raxx.Response.conflict(new_page_content(customer, %CreateForm{email: "is already taken"}, ""))
              customer = %{id: id} ->
                try do
                  UM.Web.Emails.account_created(customer) |> UM.Web.Mailer.deliver_now
                rescue
                  e ->
                    IO.warn(inspect(e))
                end
                Raxx.Patch.redirect("/customers/#{id}")
                |> UM.Web.with_flash(success: "Welcome to Useful Music")
                |> UM.Web.with_session(UM.Web.Session.login(session, customer))
            end
        end
      true ->
        Raxx.Patch.redirect("/", success: "Already logged in")
    end
  end

  def handle_request(request = %{path: [id | rest]}, _) do
    session = UM.Web.fetch_session(request)
    case UM.Web.Session.can_view_account?(session, id) do
      true ->
        {:ok, customer} = UM.Accounts.fetch_by_id(id)
        customer_endpoint(%{request | path: rest}, customer)
      false ->
        Raxx.Response.not_found("Don't look here")
    end
  end

  def customer_endpoint(request = %{path: [], method: :GET}, customer) do
    path = ["orders"]
    customer_endpoint(%{request | path: path}, customer)
  end

  def customer_endpoint(%{path: ["orders"], method: :GET}, customer) do
    {:ok, orders} = UM.Sales.Orders.customer_history(customer)
    Raxx.Response.ok(order_history_content(orders, customer))
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
        case data.current_password == customer.password do
          true ->
            update = %{password: data.password}
            case UM.Accounts.update_customer(Map.merge(update, %{id: customer.id})) do
              {:ok, customer} ->
                Raxx.Patch.redirect("/customers/#{customer.id}", success: "Password changed")
            end
          false ->
            Raxx.Patch.redirect("/customers/#{customer.id}/change_password")
            |> UM.Web.with_flash(error: "Could not update password")
        end
      {:error, form_with_errors} ->
        IO.inspect(form_with_errors)
        Raxx.Patch.redirect("/customers/#{customer.id}/change_password")
        |> UM.Web.with_flash(error: "Could not update password")
    end
  end
end
