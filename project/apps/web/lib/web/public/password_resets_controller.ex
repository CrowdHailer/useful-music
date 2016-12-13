defmodule UM.Web.PasswordResetsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:unknown_email]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:token, :email]


  def handle_request(%{path: ["new"], method: :GET}, _) do
    Raxx.Response.ok(new_page_content(nil))
  end

  def handle_request(%{path: [], method: :POST, body: %{"customer" => form}}, _) do
    email = Map.get(form, "email", "")
    case UM.Accounts.create_password_reset(email) do
      {:ok, customer} ->
        # send email
        Raxx.Patch.redirect("/sessions/new", success: "A password reset has been sent to your email")
      {:error, :no_customer} ->
        Raxx.Response.ok(new_page_content(email))
    end
  end

  def handle_request(%{path: [token, "edit"], method: :GET, query: %{"email" => email}}, _) do
    Raxx.Response.ok(edit_page_content(token, email))
  end

  def handle_request(%{path: [token], method: :PUT, body: body}, _) do
    # validate length of password
    email = body["email"]
    case UM.Accounts.find_by_email(email) do
      {:ok, customer} ->
        case UM.Accounts.Customer.reset_password(customer, %{
          password: body["customer"]["password"],
          token: token
        }) do
          {:ok, updated} ->
            UM.Accounts.update_customer(updated)
            Raxx.Patch.redirect("/sessions/new", success: "Password changed")
        end
      {:error, :invalid_token} ->
        Raxx.Patch.redirect("/password_resets/new", error: "Reset token invalid or expired")
      #   {:error, :token_expired} ->
    end
  end

  def csrf_tag do
    "" # TODO
  end

  def use_token do
    # OK.try do
    #   data <- ChangePasswordForm.validate(form)
    #   customer <- UM.Accounts.authenticate_by_token(email, token)
    #   patch = Map.merge(%{
    #     id: customer.id,
    #     password_reset_token: nil,
    #     password_reset_created_at: nil,
    #     password: data.password})
    #   customer <- UM.Accounts.update_customer(patch)
    # end
  end
end
