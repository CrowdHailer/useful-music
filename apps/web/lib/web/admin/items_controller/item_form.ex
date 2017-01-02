defmodule UM.Web.Admin.ItemsController.ItemForm do
  def validate(form) do
    validator = %{
      piece_id: WebForm.integer(required: true),
      name: UM.Web.FormFields.any(required: true),
      asset: WebForm.file(empty: {:ok, nil}),
      initial_price: UM.Web.FormFields.price_in_pounds(required: true),
      discounted_price: UM.Web.FormFields.price_in_pounds(default: nil)
      # DEBT should not need to set blank value
      # discounted_price: UM.Web.FormFields.price_in_pounds(blank: {:ok, nil})
    }
    WebForm.validate(validator, form)
  end
end
