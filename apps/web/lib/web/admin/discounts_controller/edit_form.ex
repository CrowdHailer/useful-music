defmodule UM.Web.Admin.DiscountsController.EditForm do
  import UM.Web.FormFields

  def validate(form) do
    validator = %{
      code: discount_code(required: true),
      value: UM.Web.FormFields.price_in_pounds(required: true),
      allocation: WebForm.integer(required: true),
      customer_allocation: WebForm.integer(required: true),
      start_datetime: date(required: true),
      end_datetime: date(required: true),
    }
    WebForm.validate(validator, form)
  end
end
