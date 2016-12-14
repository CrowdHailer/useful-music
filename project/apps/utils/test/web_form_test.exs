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

  defp greeting_validator("hello"), do: {:ok, "Hello"}
  defp greeting_validator(other) when is_binary(other), do: {:error, :unknown_greeting}

  defp any_value(input) when is_binary(input), do: {:ok, input}
end
