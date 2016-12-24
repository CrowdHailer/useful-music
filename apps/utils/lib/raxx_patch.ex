defmodule Raxx.Patch do
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

  def follow(response) do
    location = Raxx.Patch.response_location(response)
    Raxx.Request.get(location)
  end

  @doc """
  get content, having parsed content type

  could alternativly have Request.form
  this should be extensible, have multipart form as a separate project
  # type spec, this should return an error for un parsable content
  """
  def form_content(request) do
    case Raxx.Headers.content_type(request) do
      {"multipart/form-data", "boundary=" <> boundary} ->
        {:ok, Raxx.Request.parse_multipart_form_data(request.body, boundary)}
      {"application/x-www-form-urlencoded", _} ->
        {:ok, URI.decode_query(request.body)}
      :undefined ->
        {:error, :not_a_form}
    end
  end

  @doc """
  content type is a field of type media type (same as Accept)
  https://tools.ietf.org/html/rfc7231#section-3.1.1.5

  Content type should be send with any content.
  If not can assume "application/octet-stream" or try content sniffing.
  because of security risks it is recommended to be able to disable sniffing
  """
  # def content_type(%{headers: headers}) do
  #   case :proplists.get_value("content-type", headers) do
  #     :undefined ->
  #       :undefined
  #     media_type ->
  #       Raxx.Request.parse_media_type(media_type)
  #   end
  # end
end
