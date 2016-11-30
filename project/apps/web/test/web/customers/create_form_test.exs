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

  test "sandbox" do
    {:ok, data} = CreateForm.validate(@valid_form)
    |> IO.inspect
  end

  test "requires a first name" do
    {:error, {form, errors}} = CreateForm.validate(%{@valid_form | "first_name" => ""})
    assert form.first_name == ""
    assert errors.first_name == :required
  end

  test "coerces first name" do
    {:ok, data} = CreateForm.validate(%{"first_name" => "  will"})
    assert data.first_name == "Will"
  end

  @tag :skip
  test "short name is invalid" do
    {data, errors} = CreateForm.validate(%{"first_name" => "I"})
    assert data.first_name == nil
    assert errors.first_name == "name is too short"
  end

  @tag :skip
  test "long name is invalid" do
    {data, errors} = CreateForm.validate(%{"first_name" => "1111111111111111111111111111"})
    assert data.first_name == nil
    assert errors.first_name == "name is too long"
  end


  @tag :skip
  test "cleans valid last name" do
    {data, errors} = CreateForm.validate(%{"last_name" => " Smith  "})
    assert data.last_name == "Smith"
    assert errors.last_name == nil
  end

  @tag :skip
  test "requires a last name" do
    {data, errors} = CreateForm.validate(%{"last_name" => ""})
    assert data.last_name == nil
    assert errors.last_name == "name is required"
  end

    @tag :skip
  test "cleans email" do
    {data, errors} = CreateForm.validate(%{"email" => " Dummy@ExamplE.com  "})
    assert data.email == "dummy@example.com"
    assert errors.email == nil
  end

  @tag :skip
  test "requires an email" do
    {data, errors} = CreateForm.validate(%{"email" => ""})
    assert data.email == nil
    assert errors.email == "email is required"
  end
end
