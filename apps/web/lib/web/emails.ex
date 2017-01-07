defmodule UM.Web.Emails do
  import Bamboo.Email
  import UM.Web.ViewHelpers
  require EEx

  account_created_html_template = String.replace_suffix(__ENV__.file, ".ex", "/account_created.html.eex")
  EEx.function_from_file :def, :account_created_html_email, account_created_html_template, [:customer, :account_url]

  account_created_text_template = String.replace_suffix(__ENV__.file, ".ex", "/account_created.txt.eex")
  EEx.function_from_file :def, :account_created_text_email, account_created_text_template, [:customer, :account_url]

  password_reset_created_html_template = String.replace_suffix(__ENV__.file, ".ex", "/password_reset_created.html.eex")
  EEx.function_from_file :def, :password_reset_created_html_email, password_reset_created_html_template, [:customer, :password_reset_url]

  password_reset_created_text_template = String.replace_suffix(__ENV__.file, ".ex", "/password_reset_created.txt.eex")
  EEx.function_from_file :def, :password_reset_created_text_email, password_reset_created_text_template, [:customer, :password_reset_url]

  def account_created(customer, account_url) do
    new_email
      |> to(customer.email)
      |> from("info@usefulmusic.com")
      |> subject("Welcome to usefulmusic.com")
      |> html_body(account_created_html_email(customer, account_url))
      |> text_body(account_created_text_email(customer, account_url))
  end

  def password_reset_created(customer, password_reset_url) do
    new_email
      |> to(customer.email)
      |> from("info@usefulmusic.com")
      |> subject("Useful Music password reset")
      |> html_body(password_reset_created_html_email(customer, password_reset_url))
      |> text_body(password_reset_created_text_email(customer, password_reset_url))
  end
end
defmodule UM.Web.Mailer do
  use Bamboo.Mailer, otp_app: :web
end
