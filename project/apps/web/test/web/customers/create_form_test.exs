defmodule UM.Web.Customers.CreateFormTest do
  use ExUnit.Case, async: true

  alias UM.Web.Customers.CreateForm

  test "cleans valid first name" do
    {data, errors} = CreateForm.validate(%{"first_name" => "  will"})
    assert data.first_name == "Will"
    assert errors.first_name == nil
  end

  test "short name is invalid" do
    {data, errors} = CreateForm.validate(%{"first_name" => "I"})
    assert data.first_name == nil
    assert errors.first_name == "name is too short"
  end

  test "cleans valid last name" do
    {data, errors} = CreateForm.validate(%{"last_name" => " Smith  "})
    assert data.last_name == "Smith"
    assert errors.last_name == nil
  end
end
