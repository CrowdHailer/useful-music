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
