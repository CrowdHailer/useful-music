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
end
