defmodule UM.Web.PasswordResetsController.ResetPasswordForm do
  import UM.Web.FormFields

  def validate(form) do
    validator = %{
      email: email(required: true),
      password: password(required: true),
      password_confirmation: password_confirmation,
    }
    WebForm.validate(validator, form)
  end
end
