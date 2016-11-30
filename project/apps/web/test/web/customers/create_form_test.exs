defmodule UM.Web.Customers.CreateFormTest do
  use ExUnit.Case, async: true

  alias UM.Web.Customers.CreateForm

  @valid_form %{
    "first_name" => "Will",
    "last_name" => "Smith",
    "email" => "smithy@example.com",
    "password" => "password",
    "password_confirmation" => "password",
    "country" => "TODO",
    "terms_agreement" => "on"
  }

  # TODO something useful
  test "sandbox" do
    {:ok, _data} = CreateForm.validate(@valid_form)
    # |> IO.inspect
  end

  test "requires a first name" do
    {:error, {form, errors}} = CreateForm.validate(%{@valid_form | "first_name" => ""})
    assert form.first_name == ""
    assert errors.first_name == :required
  end

  test "coerces first name" do
    {:ok, data} = CreateForm.validate(%{@valid_form | "first_name" => "  will"})
    assert data.first_name == "Will"
  end

  test "short name is invalid" do
    {:error, {data, errors}} = CreateForm.validate(%{"first_name" => "I"})
    assert data.first_name == "I"
    assert errors.first_name == "name is too short"
  end

  test "long name is invalid" do
    {:error, {_data, errors}} = CreateForm.validate(%{"first_name" => "1111111111111111111111111111"})
    assert errors.first_name == "name is too long"
  end

  test "cleans valid last name" do
    {:ok, data} = CreateForm.validate(%{@valid_form | "last_name" => " Smith  "})
    assert data.last_name == "Smith"
  end

  test "cleans email" do
    {:ok, data} = CreateForm.validate(%{@valid_form | "email" => " Dummy@ExamplE.com  "})
    assert data.email == "dummy@example.com"
  end

  test "requires an email" do
    {:error, {data, errors}} = CreateForm.validate(%{@valid_form | "email" => ""})
    assert data.email == ""
    assert errors.email == :required
  end

  test "requires a password" do
    {:error, {form, errors}} = CreateForm.validate(%{@valid_form | "password" => ""})
    assert form.password == ""
    assert errors.password == :required
  end

  test "requires a password confirmation" do
    {:error, {_form, errors}} = CreateForm.validate(%{@valid_form | "password_confirmation" => "other"})
    assert errors.password_confirmation == :does_not_match
  end

  test "requires a country" do
    {:error, {_form, errors}} = CreateForm.validate(%{@valid_form | "country" => ""})
    assert errors.country == :required
  end

  test "requires aggreement" do
    {:error, {_form, errors}} = CreateForm.validate(%{@valid_form | "terms_agreement" => "off"})
    assert errors.terms_agreement == :checkbox_needs_accepting
  end
end
