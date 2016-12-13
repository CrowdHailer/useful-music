defmodule UM.Web.PasswordResetsController do
  def handle_request(%{path: [], method: :GET}) do
    Raxx.Response.ok("hello")
  end

  def handle_request(%{path: [], method: :POST, body: %{"customer" => form}}) do
    case UM.Accounts.create_password_reset(Map.get(form, "email", "")) do
      {:ok, customer} ->
        # send email
        Raxx.Patch.redirect("/session/new", success: "A password reset has been sent to your email")
      {:error, :no_customer} ->
        Raxx.Response.ok("Email not found")
    end
  end
end
