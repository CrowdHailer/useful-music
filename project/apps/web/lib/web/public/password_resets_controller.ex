defmodule UM.Web.PasswordResetsController do
  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:unknown_email]


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

  def csrf_tag do
    "" # TODO
  end
end
