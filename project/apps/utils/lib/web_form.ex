# Object and patching forms
# Action forms
# Does the domain action have enough reach to specify form fields in the browser?
# how to handle errors that are not available to the form.
#   such as when a uniqueness constraint has failed.
# How to handle rich fields
# Such as a when a date is specified as day, month and year
# Differences between empty and nil.
# String field to set value to empty and string field missing
#   "" -> delete this value
#   "" -> leave this value unchanged
#   If a form is an edit page then "" means delete this value
#   optional string min length 3 -> "" or "123"
#   required string min length 3 ->
# perhaps make the assumption that form objects map to pages so assume all fields present
# If it's optional it has to have a default value, default of nil means optional

# import Heimdall.Fields
# id: integer(min: 100, max: 999, default: nil)
# id: string(pattern: ~r/a*/, default: "") this field will overwrite fields if the form is missing it
# id: string(pattern: ~r/a*/, default: nil) this field should not?
# id: file(default: nil)
# first_name: field(validate: &UM.Name.validate/1)
# first_name: field(validate: &UM.Name.validate/1, pass_blank: true)
# first_name: field(validate: &Heimdall.Fields.Number.validate(&1, min: 0, max: 100))
# first_name: field(validate: &Heimdall.Fields.Checkbox.validate(&1, false: "off", true: "on"))
# Raxx.Upload.EmptyFile
# first_name: NameField

defmodule WebForm do
  def validate(validator, form) do
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
      {key, {:optional, fun}} ->
        case Map.get(form, "#{key}", "") do
          "" ->
            {key, {:ok, ""}}
          value ->
            case fun.(value) do
              {:ok, validated} ->
                {key, {:ok, validated}}
              {:error, reason} ->
                {key, {:error, reason, value}}
            end
        end
      {key, {:boolean, default}} ->
        case Map.get(form, "#{key}") do
          :nil ->
            {key, {:ok, default}}
          "on" ->
            {key, {:ok, true}}
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
        {form, errors} = Enum.reduce(validated, {validator, validator}, fn
          ({key, {:ok, value}}, {form, errors}) ->
            {%{form | key => value}, %{errors| key => nil}}
          ({key, {:error, reason, raw}}, {form, errors}) ->
            {%{form | key => raw}, %{errors| key => reason}}
        end)
        {:error, {form, errors}}
    end
  end

  def validate_integer(raw) do
    case Integer.parse(raw) do
      {i, ""} -> {:ok, i}
      _ -> {:error, :not_and_integer, raw}
    end
  end
  def validate_float(raw) do
    case Float.parse(raw) do
      {f, ""} -> {:ok, f}
      _ -> {:error, :not_and_integer, raw}
    end
  end
end
