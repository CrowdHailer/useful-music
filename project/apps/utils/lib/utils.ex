defmodule Utils do
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def sub_form(form, top_key) do
    regex = ~r/#{top_key}\[(?<attr>[^\]]*)\]/
    form = Enum.flat_map(form, fn
      ({key, value}) ->
        case Regex.named_captures(regex, key) do
          %{"attr" => attribute} ->
            [{attribute, value}]
          nil ->
            []
        end
    end)
    |> Enum.into(%{})
  end
end
