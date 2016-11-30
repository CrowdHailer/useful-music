# Rename SignUpForm
defmodule UM.Web.Customers.CreateForm do
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
    validator = %{
      first_name: {:required, &validate_name/1},
      last_name: {:required, &validate_name/1},
      email: {:required, &validate_email/1},
      password: {:required, &validate_password/1},
      password_confirmation: {:confirmation, "password"},
      country: {:required, fn(x) -> {:ok, x} end},
      terms_agreement: :required_checkbox
    }
    WebForm.validate(validator, form)
  end

  # TODO validate contains letters only
  def validate_name(text) do
    name = String.strip(text) |> String.capitalize
    case String.length(name) >= 2 do
      false ->
        {:error, "name is too short"}
      true ->
        case String.length(name) <= 26 do
          false ->
            {:error, "name is too long"}
          true ->
            {:ok, name}
        end
    end
  end
  def validate_password(text) do
    case String.length(text) >= 8 do
      false ->
        {:error, "text is too short"}
      true ->
        case String.length(text) <= 55 do
          false ->
            {:error, "text is too long"}
          true ->
            {:ok, text}
        end
    end
  end

  defp validate_email(raw) do
    case String.split(raw, "@") do
      [_, _] ->
        {:ok, raw |> String.strip |> String.downcase}
      _ ->
        {:error, "not a vaild email address"}
    end
  end

end
