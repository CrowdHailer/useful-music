defmodule UM.Web.Admin.ItemsController.ItemForm do
  def validate(form) do
    validator = %{
      piece_id: WebForm.integer(required: true),
      name: UM.Web.FormFields.any(required: true),
      asset: WebForm.field(fn
        (%{content: ""}) -> {:ok, :file_not_provided}
        (x) -> {:ok, x.filename}
      end),
      initial_price: UM.Web.FormFields.price_in_pounds(required: true),
      discounted_price: UM.Web.FormFields.price_in_pounds()
    }
    WebForm.validate(validator, form)
  end
end
