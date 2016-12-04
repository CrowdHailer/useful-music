# UM.Web

- Generalise context object for public pages
  user %{id: maybe(string), currency_preference: "USD" | "GBP" | "EUR"}
  guest as a function
  name as a function
  shopping_basket %{id: string, number_of_purchases: number, price :number}
  snapshot that is replaced in session on editing
  error from flash
  success from flash
  Would be nice to call these messages but don't care
- Handle invalid content values or assume octet content. check RFC.
  make the parser return a `try` tuple
- Setup method overwrite middleware
- create piece tests, generalise form, push upload content to db.
- improve session api, note response will overwrite session if it lives in a single location.


- Have Admin and public domains for application.
- TODO, generate styles from asset files
- TODO, use relative links in templates

Ways to handle controller

```elixir
# OK.success(request)
# ~>> Raxx.Request.read_form
# ~>> Map.fetch("customer")
# ~>> CreateForm.populate()
# ~>> UM.Customer.create

# Try.for do
#   form <- Raxx.Request.decode_www_form(request.body, key: "customer")
#   data <- WebForm.populate(UM.Customers.SignUpForm, form)
#   reaction <- UM.Customers.signup(data, %{REPO: env.customer_repo})
# end
```
