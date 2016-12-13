defmodule UM.Accounts.Customer do
  def reset_password(customer, %{password: password, token: token}) do
    # TODO check token expiry
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
end
