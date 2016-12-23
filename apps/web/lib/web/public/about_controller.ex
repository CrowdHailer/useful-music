defmodule UM.Web.AboutController do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, []

  def handle_request(%{path: []}, _env) do
    Raxx.Response.ok(index_page_content)
  end

  composers_file = String.replace_suffix(__ENV__.file, ".ex", "/composers.html.eex")
  EEx.function_from_file :def, :composers_page_content, composers_file, []

  def handle_request(%{path: ["composers"]}, _env) do
    Raxx.Response.ok(composers_page_content)
  end

  search_and_purchase_file = String.replace_suffix(__ENV__.file, ".ex", "/search_and_purchase.html.eex")
  EEx.function_from_file :def, :search_and_purchase_page_content, search_and_purchase_file, []

  def handle_request(%{path: ["search_and_purchase"]}, _env) do
    Raxx.Response.ok(search_and_purchase_page_content)
  end

  licencing_and_copyright_file = String.replace_suffix(__ENV__.file, ".ex", "/licencing_and_copyright.html.eex")
  EEx.function_from_file :def, :licencing_and_copyright_page_content, licencing_and_copyright_file, []

  def handle_request(%{path: ["licencing_and_copyright"]}, _env) do
    Raxx.Response.ok(licencing_and_copyright_page_content)
  end

  refunds_file = String.replace_suffix(__ENV__.file, ".ex", "/refunds.html.eex")
  EEx.function_from_file :def, :refunds_page_content, refunds_file, []

  def handle_request(%{path: ["refunds"]}, _env) do
    Raxx.Response.ok(refunds_page_content)
  end

  privacy_file = String.replace_suffix(__ENV__.file, ".ex", "/privacy.html.eex")
  EEx.function_from_file :def, :privacy_page_content, privacy_file, []

  def handle_request(%{path: ["privacy"]}, _env) do
    Raxx.Response.ok(privacy_page_content)
  end

  terms_and_conditions_file = String.replace_suffix(__ENV__.file, ".ex", "/terms_and_conditions.html.eex")
  EEx.function_from_file :def, :terms_and_conditions_page_content, terms_and_conditions_file, []

  def handle_request(%{path: ["terms_and_conditions"]}, _env) do
    Raxx.Response.ok(terms_and_conditions_page_content)
  end

  contact_file = String.replace_suffix(__ENV__.file, ".ex", "/contact.html.eex")
  EEx.function_from_file :def, :contact_page_content, contact_file, []

  def handle_request(%{path: ["contact"]}, _env) do
    Raxx.Response.ok(contact_page_content)
  end

  sitemap_file = String.replace_suffix(__ENV__.file, ".ex", "/sitemap.html.eex")
  EEx.function_from_file :def, :sitemap_page_content, sitemap_file, []

  def handle_request(%{path: ["sitemap"]}, _env) do
    Raxx.Response.ok(sitemap_page_content)
  end
end
