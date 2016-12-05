defmodule Raxx.Test do
  # TODO stringify query keys
  def get(url, body \\ "", headers \\ []) do
    build(:GET, url, body, headers)
  end

  def post(url, body \\ "", headers \\ []) do
    build(:POST, url, body, headers)
  end

  def delete(url, body \\ "", headers \\ []) do
    build(:DELETE, url, body, headers)
  end

  def form_data(data) do
    %{
      headers: [{"content-type", "application/x-www-form-urlencoded"}],
      body: Plug.Conn.Query.encode(data)
    }
  end

  defp build(method, url, body, headers) when is_binary(url) do
    {url, query} = case String.split(url, "?") do
      [url, qs] ->
        query = URI.decode_query(qs)
        {url, query}
      [url] ->
        {url, %{}}
    end
    build(method, url, query, body, headers)
  end
  defp build(method, {url, query}, body, headers) do
    # TODO check url string for query
    build(method, url, query, body, headers)
  end
  defp build(method, url, query, body, headers) when is_list(body) do
    build(method, url, query, "", body ++ headers)
  end
  defp build(method, url, query, %{headers: headers, body: body}, extra_headers) do
    build(method, url, query, body, headers ++ extra_headers)
  end
  defp build(method, url, query, body, headers) do
    path = Raxx.Request.split_path(url)
    # Done to stringify keys
    query = query |> Plug.Conn.Query.encode |> Plug.Conn.Query.decode
    %Raxx.Request{
      method: method,
      path: path,
      query: query,
      headers: headers,
      body: body
    }
  end
end
