defmodule UM.Web.Emails do
  import Bamboo.Email
  import UM.Web.ViewHelpers
  require EEx

  account_created_html_template = String.replace_suffix(__ENV__.file, ".ex", "/account_created.html.eex")
  EEx.function_from_file :def, :account_created_html_email, account_created_html_template, [:customer, :account_url]

  account_created_text_template = String.replace_suffix(__ENV__.file, ".ex", "/account_created.txt.eex")
  EEx.function_from_file :def, :account_created_text_email, account_created_text_template, [:customer, :account_url]

  def account_created(customer, account_url) do
    new_email
      |> to(customer.email)
      |> from("info@usefulmusic.com")
      |> subject("Welcome to usefulmusic.com")
      |> html_body(account_created_html_email(customer, account_url))
      |> text_body(account_created_text_email(customer, account_url))
  end
end
defmodule UM.Web.Mailer do
  use Bamboo.Mailer, otp_app: :web
end
