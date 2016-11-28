defmodule UM.Web.Customers.CreateFormTest do
  use ExUnit.Case, async: true

  alias UM.Web.Customers.CreateForm

  test "coerces first name" do
    {data, errors} = CreateForm.validate(%{"first_name" => "  will"})
    assert data.first_name == "Will"
    assert errors.first_name == nil
  end

  test "short name is invalid" do
    {data, errors} = CreateForm.validate(%{"first_name" => "I"})
    assert data.first_name == nil
    assert errors.first_name == "name is too short"
  end

  test "long name is invalid" do
    {data, errors} = CreateForm.validate(%{"first_name" => "1111111111111111111111111111"})
    assert data.first_name == nil
    assert errors.first_name == "name is too long"
  end

  test "requires a first name" do
    {data, errors} = CreateForm.validate(%{"first_name" => ""})
    assert data.first_name == nil
    assert errors.first_name == "name is required"
  end

  test "cleans valid last name" do
    {data, errors} = CreateForm.validate(%{"last_name" => " Smith  "})
    assert data.last_name == "Smith"
    assert errors.last_name == nil
  end

  test "requires a last name" do
    {data, errors} = CreateForm.validate(%{"last_name" => ""})
    assert data.last_name == nil
    assert errors.last_name == "name is required"
  end

  test "cleans email" do
    {data, errors} = CreateForm.validate(%{"email" => " Test@ExamplE.com  "})
    assert data.email == "test@example.com"
    assert errors.email == nil
  end

  test "requires an email" do
    {data, errors} = CreateForm.validate(%{"email" => ""})
    assert data.email == nil
    assert errors.email == "email is required"
  end
end
