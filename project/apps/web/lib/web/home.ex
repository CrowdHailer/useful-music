defmodule UM.Web.Home do
  def handle_request(request = %{path: []}, _env) do
    Raxx.Response.ok()
  end

  instruments = [
    "piano",
    "recorder",
    "flute"
  ]
  for instrument <- instruments do
    def handle_request(request = %{path: [unquote(instrument)]}, _env) do
      Raxx.Response.found("", [{"location", "/pieces?catalogue_search[#{unquote(instrument)}]=on"}])
    end

  end

  def handle_request(_, _) do
    Raxx.Response.not_found()
    # TODO make this work
    # UM.Web.not_found()
  end
end
