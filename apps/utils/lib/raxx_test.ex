defmodule Raxx.Test do
  def form_data(data) do
    # DEBT stringify keys
    %{
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      body: data
    }
  end

  def encode_form(data) do
    %{
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      body: Plug.Conn.Query.encode(data)
    }
  end
end
