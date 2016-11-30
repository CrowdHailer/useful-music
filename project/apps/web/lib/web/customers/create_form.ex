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
      first_name: {:required, &validate_name/1}
    }
    validated = Enum.map(validator, fn
      {key, {:required, fun}} ->
        case Map.get(form, "#{key}", "") do
          "" ->
            {key, {:error, :required, ""}}
          name ->
            case fun.(name) do
              {:ok, validated} ->
                {key, {:ok, validated}}
            end
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
  def validate(form) do
    data = %__MODULE__{} # should be action struct signup not signupform
    errors = %__MODULE__{}

    {data, errors} = case validate_name(Map.get(form, "first_name", "")) do
      {:ok, first_name} ->
        {Map.merge(data, %{first_name: first_name}), Map.merge(errors, %{first_name: nil})}
      {:error, reason} ->
        {Map.merge(data, %{first_name: nil}), Map.merge(errors, %{first_name: reason})}
    end

    {data, errors} = case validate_name(Map.get(form, "last_name", "")) do
      {:ok, last_name} ->
        {Map.merge(data, %{last_name: last_name}), Map.merge(errors, %{last_name: nil})}
      {:error, reason} ->
        {Map.merge(data, %{last_name: nil}), Map.merge(errors, %{last_name: reason})}
    end

    {data, errors} = case validate_email(Map.get(form, "email", "")) do
      {:ok, email} ->
        {Map.merge(data, %{email: email}), Map.merge(errors, %{email: nil})}
      {:error, reason} ->
        {Map.merge(data, %{email: nil}), Map.merge(errors, %{email: reason})}
    end
    {data, errors} = case Map.get(form, "terms_agreement", "off") do
      "on" ->
        {Map.merge(data, %{terms_agreement: true}), Map.merge(errors, %{terms_agreement: nil})}
      _ ->
        {Map.merge(data, %{terms_agreement: nil}), Map.merge(errors, %{terms_agreement: "must say yes"})}
    end

    # TODO fix these merges
    data = %{data | password: "hello", country: "GB"}
    {data, errors}
  end

  # TODO validate contains letters only
  def validate_name("") do
    # This is an odd error because it should not be part of the validator
    {:error, "name is required"}
  end
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

  defp validate_email("") do
    # This is an odd error because it should not be part of the validator
    {:error, "email is required"}
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
