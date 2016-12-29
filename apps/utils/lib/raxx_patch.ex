defmodule Raxx.Patch do
  @doc """
  Adds a set cookie header to the response.

  For options see `Raxx.Cookie.Attributes`
  """
  def set_cookie(r = %{headers: headers}, key, value, options \\ %{}) do
    cookies = Map.get(headers, "set-cookie", [])
    %{r | headers: Map.merge(headers, %{"set-cookie" => cookies ++ [Raxx.Cookie.new(key, value, options) |> Raxx.Cookie.set_cookie_string]})}
  end

  @doc """
  Adds a cookie header to the response, that will expire the cookie with the given key.

  **NOTE:** Will not expire session cookies.
  """
  def expire_cookie(r = %{headers: headers}, key) do
    cookies = Map.get(headers, "set-cookie", [])
    %{r | headers: %{"set-cookie" => cookies ++ ["#{key}=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/"]}}
  end


  def get_header(request, key) do
    # check {:ok value} semantics
    {^key, value} = List.keyfind(request.headers, key, 0)
    value
  end

  def referrer(%{headers: headers}) do
    case List.keyfind(headers, "referer", 0) do
      {"referer", referrer} ->
        referrer
      _ ->
      nil
    end
  end

  def response_location(%{headers: headers}) do
    case List.keyfind(headers, "location", 0) do
      {"location", location} ->
        location
      _ ->
        nil
    end
  end

  def response_session(%{headers: headers}) do
    case List.keyfind(headers, "um-set-session", 0) do
      {"um-set-session", session} ->
        session
      _ ->
        nil
    end
  end
  # FIXME delegate to request/response
  def set_header(request = %{headers: headers}, key, value) do
    # downcase
    false = List.keymember?(headers, key, 0)

    headers = headers ++ [{key, value}]
    request = %{request| headers: headers}
    {:ok, request}
  end

  @doc """
  redirect to a new url.

  Don't have flash explicitly named?
  use function head of the form
  redirect(url)
  redirect({path, query})
  redirect(url, body) # pattern match
  redirect(url, headers)
  redirect(url, content, extra_headers)

  Return a `Raxx.Response` that informs the client that the resouce has been found elsewhere.

  This function sets a `Location` header as well as sending a redirection page.
  """
  def redirect(url, flash) do
    flash = Enum.into(flash, %{})
    flash = Poison.encode!(flash)
    query = URI.encode_query(%{flash: flash})
    Raxx.Response.found("", [{"location", url <> "?" <> query}])
  end
  def redirect({url, query}) do
    qs = Plug.Conn.Query.encode(query)
    Raxx.Response.found("", [{"location", url <> "?" <> qs}])
  end
  def redirect(url) do
    Raxx.Response.found("", [{"location", url}])
  end

  defp redirect_page(path) do
    """
      <html><body>You are being <a href=\"#{ escape(path) }\">redirected</a>.</body></html>
    """
  end
  # For redirect consider string/tuple/map url
  # consider mount middleware adjusting paths
  # consider marking redirects as absolute

  # needed for redirect
  @escapes [
    {?<, "&lt;"},
    {?>, "&gt;"},
    {?&, "&amp;"},
    {?", "&quot;"},
    {?', "&#39;"}
  ]

  Enum.each @escapes, fn { match, insert } ->
    defp escape_char(unquote(match)), do: unquote(insert)
  end

  defp escape_char(char), do: << char >>

  @doc false
  defp escape(buffer) do
    IO.iodata_to_binary(for <<char <- buffer>>, do: escape_char(char))
  end

  def follow(response) do
    location = Raxx.Patch.response_location(response)
    Raxx.Request.get(location)
  end
end
