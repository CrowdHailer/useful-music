defmodule UM.Web.Pieces do
  @moduledoc """
  This controller is really the catalogue domain.
  items should be subpaths off this controller.
  """
  # def handle_request(%{path: []}, _env) do
  #   # FIXME directly call query
  #   query = Map.get(request.query, "catalogue_search", "")
  #   Catalogue.search(query)
  # end
  #
  # def handle_request(request = %{path: ["search"]}, _env) do
  #   search = Map.get(request.query, "search", "")
  #   case Catalogue.lookup(search) do
  #     nil ->
  #       %Catalogue.Search{title: search} |> to_query_string
  #     %{id: id} ->
  #       # Maybe make a `found_at` method
  #       Raxx.Response.found("", [{"location", "./#{id}"}])
  #       # Have middleware that expands relative location
  #   end
  # end
  #
  # def handle_request(request = %{path: [id]}, _env) do
  #   case Catalogue.lookup(search) do
  #     nil ->
  #       # TODO escape warning message
  #       Raxx.Response.found("", [{"location", "/?warning=Piece not found"}])
  #     %{id: id} ->
  #       Raxx.Response.ok()
  #     end
  # end
end
