defmodule UM.Web.Customers do
  # Rename SignUpForm
  defmodule CreateForm do
    # All of these fields are required
    # extra fields are not necessary a problem but might clash with db rows, unlikely
    defstruct [
      first_name: nil,
      last_name: nil,
      email: nil,
      password: nil,
      password_confirmation: nil, # hmmm
      country: nil,
      terms_agreement: nil # hmmm
    ]

    def validate(form) do
      data = %{}
      errors = %{}

      {data, errors} = case validate_name(Map.get(form, "first_name")) do
        {:ok, first_name} ->
          {Map.merge(data, %{first_name: first_name}), Map.merge(errors, %{first_name: nil})}
        {:error, reason} ->
          {Map.merge(data, %{first_name: nil}), Map.merge(errors, %{first_name: reason})}
      end

      {data, errors} = case validate_name(Map.get(form, "last_name")) do
        {:ok, last_name} ->
          {Map.merge(data, %{last_name: last_name}), Map.merge(errors, %{last_name: nil})}
        {:error, reason} ->
          {Map.merge(data, %{last_name: nil}), Map.merge(errors, %{last_name: reason})}
      end
    end

    def validate_name(nil) do
      # This is an odd error because it should not be part of the validator
      {:error, "name is required"}
    end
    def validate_name(text) do
      name = String.strip(text) |> String.capitalize
      case String.length(name) >= 2 do
        true ->
          {:ok, name}
        false ->
          {:error, "name is too short"}
      end
    end

    def populate(raw) do
      {:ok, email} = Map.get(raw, "email") |> validate_email
      {:ok, password} = Map.fetch(raw, "password")
      {:ok, ^password} = Map.fetch(raw, "password_confirmation")
      {:ok, first_name} = Map.fetch(raw, "first_name")
      {:ok, last_name} = Map.fetch(raw, "last_name")
      {:ok, %{
        email: email,
        password: password,
        first_name: first_name,
        last_name: last_name
        }}
    end

    defp validate_email(raw) do
      case String.split(raw, "@") do
        [_, _] ->
          {:ok, raw |> String.strip |> String.downcase}
        _ ->
          {:error, "not a vail email address"}
      end
    end

  end

  require EEx

  new_file = String.replace_suffix(__ENV__.file, ".ex", "/new.html.eex")
  EEx.function_from_file :def, :new_page_content, new_file, [:form, :errors, :success_path]

  def handle_request(request = %{method: :GET, path: ["new"]}, _) do
    Raxx.Response.ok(new_page_content(%CreateForm{}, %CreateForm{}, ""))
  end

  def csrf_tag do
# TODO
  end

  def handle_request(request = %{path: ["create"]}, _env) do
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

    case request.body |> Plug.Conn.Query.decode |> Map.fetch("customer")  do
      {:ok, raw} ->
        case CreateForm.populate(raw) do
          {:ok, data} ->
            case create(data) do
              {:ok, _} -> Raxx.Response.created

            end
          {:error, form_with_errors} ->
            form_with_errors
            |> IO.inspect
        end
    end
  end
  defp create(data) do
    customer = data
    {:ok, customer}
  end
end
