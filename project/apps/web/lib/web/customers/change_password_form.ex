defmodule UM.Web.Customers.ChangePasswordForm do
  def validate(form) do
    validator = %{
      current_password: {:required, &UM.Web.Customers.CreateForm.validate_password/1},
      password: {:required, &UM.Web.Customers.CreateForm.validate_password/1},
      password_confirmation: {:confirmation, "password"},
    }
    WebForm.validate(validator, form)
  end

end
