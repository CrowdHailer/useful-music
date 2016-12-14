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
  defmodule Field do
    defstruct [:validator, :blank]
  end

  def checkbox(opts \\ []) do
    field(&coerce_checkbox(&1, opts), opts)
  end

  defp coerce_checkbox(raw, opts) do
    opts = Enum.into(opts, %{})
    truthy = Map.get(opts, :true, "on")
    if Map.get(opts, :required) && raw != truthy do
      {:error, :checkbox_needs_accepting}
    else
      {:ok, raw == truthy}
    end
  end

  def integer(opts \\ []) do
    field(&validate_integer(&1, opts), opts)
  end

  def validate_integer(raw, opts) do
    opts = Enum.into(opts, %{})
    case Integer.parse(raw) do
      {i, ""} ->
        min = Map.get(opts, :min)
        case min == nil || min < i do
          true ->
            max = Map.get(opts, :max)
            case max == nil || max > i do
              true ->
                {:ok, i}
              false ->
                {:error, :too_large}
            end
          false ->
            {:error, :too_small}
        end
      _ ->
        {:error, :not_an_integer}
    end
  end

  def field(validator, options \\ []) do
    options = Enum.into(options, %{})
    blank_action = case Map.fetch(options, :blank) do
      {:ok, blank_action} ->
        blank_action
      :error ->
        case Map.get(options, :required) do
          true ->
            {:error, :required}
          nil ->
            case Map.fetch(options, :default) do
              {:ok, default} ->
                {:ok, default}
              :error ->
                :continue
            end
        end
    end
    %Field{validator: validator, blank: blank_action}
  end

  def validate(validator, form) do
    validated = Enum.map(validator, fn
      {key, %Field{validator: validator, blank: blank}} ->
        case blank do
          {:error, reason} ->
            case Map.get(form, "#{key}", "") do
              # Fix to all blank strings
              "" ->
                {key, {:error, reason, ""}}
              value ->
                case validator.(value) do
                  {:ok, validated} ->
                    {key, {:ok, validated}}
                  {:error, reason} ->
                    {key, {:error, reason, value}}
                end
            end
          {:ok, value} ->
            case Map.get(form, "#{key}", "") do
              # Fix to all blank strings
              "" ->
                {key, {:ok, value}}
              value ->
                case validator.(value) do
                  {:ok, validated} ->
                    {key, {:ok, validated}}
                  {:error, reason} ->
                    {key, {:error, reason, value}}
                end
            end
          :continue ->
            case validator.(value = Map.get(form, "#{key}", "")) do
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
end
