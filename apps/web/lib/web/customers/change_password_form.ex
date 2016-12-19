defmodule UM.Web.Customers.ChangePasswordForm do
  import UM.Web.FormFields

  def validate(form) do
    validator = %{
      current_password: password(required: true),
      password: password(required: true),
      password_confirmation: password_confirmation,
    }
    WebForm.validate(validator, form)
  end

end
