defmodule UM.Accounts.Customer do
  def reset_password(customer, %{password: password, password_reset_token: token}) do
    case token == customer.password_reset_token do
      true ->
        {:ok, Map.merge(customer, %{
          password_reset_token: nil,
          password_reset_created_at: nil,
          password: password
        })}
      false ->
        {:error, :invalid_token}
    end
  end

  def name(%{first_name: first_name, last_name: last_name}) do
    "#{first_name} #{last_name}"
  end
end