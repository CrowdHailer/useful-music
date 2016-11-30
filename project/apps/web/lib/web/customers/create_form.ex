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
    validated = Enum.map(validator, fn
      {key, {:required, fun}} ->
        case Map.get(form, "#{key}", "") do
          "" ->
            {key, {:error, :required, ""}}
          value ->
            case fun.(value) do
              {:ok, validated} ->
                {key, {:ok, validated}}
              {:error, reason} ->
                {key, {:error, reason, value}}
            end
        end
      {key, {:confirmation, checks}} ->
        case Map.get(form, checks, "") == Map.get(form, "#{key}", "") do
          true ->
            {key, {:ok, :match}}
          false ->
            {key, {:error, :does_not_match, ""}}
        end
      {key, :required_checkbox} ->
        case Map.get(form, "#{key}", "off") do
          "on" ->
            {key, {:ok, :checked}}
          _ ->
            {key, {:error, :checkbox_needs_accepting, ""}}
        end
    end)
    |> Enum.into(%{})
    case Enum.all?(validated, fn
      ({k, {:ok, _value}}) -> true
      _ -> false
    end) do
      true ->
        {:ok, Enum.map(validated, fn({k, {:ok, v}}) -> {k, v} end) |> Enum.into(%{})}
      false ->
        {form, errors} = Enum.reduce(validated, {%__MODULE__{}, %__MODULE__{}}, fn
          ({key, {:ok, value}}, {form, errors}) ->
            {%{form | key => value}, errors}
          ({key, {:error, reason, raw}}, {form, errors}) ->
            {%{form | key => raw}, %{errors| key => reason}}
        end)
        {:error, {form, errors}}
    end
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
