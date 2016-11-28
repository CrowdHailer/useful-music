# UM.Web

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
