defmodule UM.Web.CustomersController.EditForm do
  defstruct [
    first_name: nil,
    last_name: nil,
    email: nil,
    password: nil,
    password_confirmation: nil, # hmmm
    country: nil,
    terms_agreement: nil # hmmm
  ]

  import UM.Web.FormFields

  def validate(form) do
    WebForm.validate(%{
      first_name: name(required: true),
      last_name: name(required: true),
      email: email(required: true),
      country: country(required: true),
      question_1: any(),
      question_2: any(),
      question_3: any(),
    }, form)
  end
end
