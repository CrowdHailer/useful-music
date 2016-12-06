defmodule UM.Web.Admin.ItemsController.ItemForm do
  def validate(form) do
    validator = %{
      id: {:optional, fn(_) -> {:ok, nil} end}, # should not need to do this
      piece_id: {:required, &WebForm.validate_integer/1},
      name: {:required, fn(x) -> {:ok, x} end},
      asset: {:required, fn(x) -> {:ok, x.filename} end},
      initial_price: {:required, &validate_price/1},
      discounted_price: {:optional, &validate_price/1}
    }
    WebForm.validate(validator, form)
  end

  def validate_price(raw) do
    case WebForm.validate_float(raw) do
      {:ok, float} ->
        {:ok, round(float * 100)} # TODO check decimal places
    end
  end
end
