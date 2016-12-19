defmodule UM.Web.Flash do
  defstruct error: nil, success: nil

  def from_request(request) do
    {flash, query} = Map.pop(request.query, "flash")
    flash = flash || Poison.encode!(%{})
    flash = case Poison.decode(flash) do
      {:ok, flash} ->
        flash
      {:error, _reason} ->
        %{}
    end

    flash = %__MODULE__{
      error: Map.get(flash, "error"),
      success: Map.get(flash, "success")
    }
    {flash, %{request | query: query}}
  end
end
