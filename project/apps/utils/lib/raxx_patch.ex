defmodule Raxx.Patch do
  def get_header(request, key) do
    # check {:ok value} semantics
    {^key, value} = List.keyfind(request.headers, key, 0)
    value
  end

  def response_location(%{headers: headers}) do
    case List.keyfind(headers, "location", 0) do
      {"location", location} ->
        location
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
end

defmodule Raxx.Session do
  # Plug sessions always use a cookie.
  # take sid(from_cookies) -> store -> sesson data

  # session -> encode -> cookie_string
  # sesson -> decode
  defmodule Open do
    # retrieve
    def retrieve(request, options) do
      cookies = Raxx.Session.parse_request_cookies(request)
      session = Map.get(cookies, "raxx.session", "")
      {:ok, session}
    end

    # stash
    def overwrite(session, response, options \\ []) do
      set_cookie_string = Raxx.Cookie.new("raxx.session", session)
      |> Raxx.Cookie.set_cookie_string
      {:ok, response} = Raxx.Patch.set_header(response, "set-cookie", set_cookie_string)
      response
    end
  end

  def parse_request_cookies(request) do
    # TODO delegate to cookies
    headers = request.headers
    {"cookie", cookie_string} = List.keyfind(headers, "cookie", 0, {"cookie", ""})
    cookies = Raxx.Cookie.parse([cookie_string])
  end


  # TODO redirect is broken
  # Raxx.Response.redirect("body")
  # |> Raxx.Response.set_cookie("user.id", "hi")
end
