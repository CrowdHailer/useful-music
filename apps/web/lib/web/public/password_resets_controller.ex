defmodule UM.Web.PasswordResetsController do
  alias UM.Web.PasswordResetsController.ResetPasswordForm
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:unknown_email]

  edit_file = String.replace_suffix(__ENV__.file, ".ex", "/edit.html.eex")
  EEx.function_from_file :def, :edit_page_content, edit_file, [:token, :email]

  def handle_request(%{path: ["new"], method: :GET}, _) do
    Raxx.Response.ok(new_page_content(nil))
  end

  def handle_request(request = %{path: [], method: :POST, body: %{"customer" => form}}, _) do
    email = Map.get(form, "email", "")
    case UM.Accounts.create_password_reset(email) do
      {:ok, customer} ->
        password_reset_url = %URI{
          host: request.host,
          port: request.port,
          path: "/password_resets/#{customer.password_reset_token}/edit?email=#{customer.email}",
          scheme: "http"
        }
        # DEBT hardcoding of scheme
        UM.Web.Emails.password_reset_created(customer, password_reset_url)
        |> UM.Web.Mailer.deliver_now
        Raxx.Patch.redirect("/sessions/new", success: "A password reset has been sent to your email")
      {:error, :not_found} ->
        Raxx.Response.ok(new_page_content(email))
    end
  end

  def handle_request(%{path: [token, "edit"], method: :GET, query: %{"email" => email}}, _) do
    Raxx.Response.ok(edit_page_content(token, email))
  end

  def handle_request(%{path: [token], method: :PUT, body: %{"customer" => form}}, _) do
    case ResetPasswordForm.validate(form) do
      {:ok, data} ->
        data = Map.put(data, :password_reset_token, token)
        case UM.Accounts.reset_password(data) do
          {:ok, customer} ->
            Raxx.Patch.redirect("/sessions/new", success: "Password changed")
          {:error, :invalid_token} ->
            Raxx.Patch.redirect("/password_resets/new", error: "Reset token invalid or expired")
        end
    end
  end
end
