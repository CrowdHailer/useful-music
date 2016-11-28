defmodule UM.Web.About do
  require EEx

  index_file = String.replace_suffix(__ENV__.file, ".ex", "/index.html.eex")
  EEx.function_from_file :def, :index_page_content, index_file, []

  def handle_request(%{path: []}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(index_page_content, session))
  end

  composers_file = String.replace_suffix(__ENV__.file, ".ex", "/composers.html.eex")
  EEx.function_from_file :def, :composers_page_content, composers_file, []

  def handle_request(%{path: ["composers"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(composers_page_content, session))
  end

  search_and_purchase_file = String.replace_suffix(__ENV__.file, ".ex", "/search_and_purchase.html.eex")
  EEx.function_from_file :def, :search_and_purchase_page_content, search_and_purchase_file, []

  def handle_request(%{path: ["search_and_purchase"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(search_and_purchase_page_content, session))
  end

  licencing_and_copyright_file = String.replace_suffix(__ENV__.file, ".ex", "/licencing_and_copyright.html.eex")
  EEx.function_from_file :def, :licencing_and_copyright_page_content, licencing_and_copyright_file, []

  def handle_request(%{path: ["licencing_and_copyright"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(licencing_and_copyright_page_content, session))
  end

  refunds_file = String.replace_suffix(__ENV__.file, ".ex", "/refunds.html.eex")
  EEx.function_from_file :def, :refunds_page_content, refunds_file, []

  def handle_request(%{path: ["refunds"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(refunds_page_content, session))
  end

  privacy_file = String.replace_suffix(__ENV__.file, ".ex", "/privacy.html.eex")
  EEx.function_from_file :def, :privacy_page_content, privacy_file, []

  def handle_request(%{path: ["privacy"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(privacy_page_content, session))
  end

  terms_and_conditions_file = String.replace_suffix(__ENV__.file, ".ex", "/terms_and_conditions.html.eex")
  EEx.function_from_file :def, :terms_and_conditions_page_content, terms_and_conditions_file, []

  def handle_request(%{path: ["terms_and_conditions"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(terms_and_conditions_page_content, session))
  end

  contact_file = String.replace_suffix(__ENV__.file, ".ex", "/contact.html.eex")
  EEx.function_from_file :def, :contact_page_content, contact_file, []

  def handle_request(%{path: ["contact"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(contact_page_content, session))
  end

  sitemap_file = String.replace_suffix(__ENV__.file, ".ex", "/sitemap.html.eex")
  EEx.function_from_file :def, :sitemap_page_content, sitemap_file, []

  def handle_request(%{path: ["sitemap"]}, session) do
    Raxx.Response.ok(UM.Web.Home.layout_page(sitemap_page_content, session))
  end
end
