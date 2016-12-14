defmodule WebFormTest do
  use ExUnit.Case
  doctest WebForm
  import WebForm

  test "a simple string field" do
    validator = %{greeting: field(&greeting_validator/1)}

    assert {:ok, data} = validate(validator, %{"greeting" => "hello"})
    assert %{greeting: "Hello"} == data
    assert {:error, {form, errors}} = validate(validator, %{"greeting" => "pineapple"})
    assert %{greeting: "pineapple"} == form
    assert %{greeting: :unknown_greeting} == errors
    assert {:error, {form, errors}} = validate(validator, %{})
    assert %{greeting: ""} == form
    assert %{greeting: :unknown_greeting} == errors
  end

  test "required field" do
    validator = %{content: field(&any_value/1, required: true)}

    assert {:ok, data} = validate(validator, %{"content" => "Good stuff"})
    assert %{content: "Good stuff"} == data
    assert {:error, {form, errors}} = validate(validator, %{"content" => ""})
    assert %{content: ""} == form
    assert %{content: :required} == errors
    assert {:error, {form, errors}} = validate(validator, %{})
    assert %{content: ""} == form
    assert %{content: :required} == errors
  end

  test "field with a default" do
    validator = %{content: field(&any_value/1, default: "Badger")}

    assert {:ok, data} = validate(validator, %{"content" => "Good stuff"})
    assert %{content: "Good stuff"} == data
    assert {:ok, data} = validate(validator, %{"content" => ""})
    assert %{content: "Badger"} == data
    assert {:ok, data} = validate(validator, %{})
    assert %{content: "Badger"} == data
  end

  test "integer validation" do
    validator = %{quantity: integer(min: 2, max: 5)}

    assert {:ok, data} = validate(validator, %{"quantity" => "3"})
    assert %{quantity: 3} == data
    assert {:error, {form, error}} = validate(validator, %{"quantity" => "1"})
    assert %{quantity: "1"} == form
    assert %{quantity: :too_small} == error
    assert {:error, {form, error}} = validate(validator, %{"quantity" => "8"})
    assert %{quantity: "8"} == form
    assert %{quantity: :too_large} == error
    assert {:error, {form, error}} = validate(validator, %{"quantity" => "guam"})
    assert %{quantity: "guam"} == form
    assert %{quantity: :not_an_integer} == error
  end

  test "integer required" do
    validator = %{quantity: integer(required: true)}

    assert {:ok, data} = validate(validator, %{"quantity" => "3"})
    assert %{quantity: 3} == data
    assert {:error, {form, error}} = validate(validator, %{"quantity" => ""})
    assert %{quantity: ""} == form
    assert %{quantity: :required} == error
  end

  test "integer with default" do
    # should invalid input be coerced
    validator = %{quantity: integer(default: 0)}

    assert {:ok, data} = validate(validator, %{"quantity" => "3"})
    assert %{quantity: 3} == data
    assert {:ok, data} = validate(validator, %{"quantity" => ""})
    assert %{quantity: 0} == data
    assert {:error, {form, error}} = validate(validator, %{"quantity" => "saphire"})
    assert %{quantity: "saphire"} == form
    assert %{quantity: :not_an_integer} == error
  end

  defp greeting_validator("hello"), do: {:ok, "Hello"}
  defp greeting_validator(other) when is_binary(other), do: {:error, :unknown_greeting}

  defp any_value(input) when is_binary(input), do: {:ok, input}
end
