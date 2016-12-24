defmodule UM.Web.AboutControllerTest do
  use ExUnit.Case
  import Raxx.Request

  test "test index page is available" do
    request = get("/")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test composers page is available" do
    request = get("/composers")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test search and purchase page is available" do
    request = get("/search_and_purchase")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test licencing and copyright page is available" do
    request = get("/licencing_and_copyright")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test refunds page is available" do
    request = get("/refunds")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test privacy page is available" do
    request = get("/privacy")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test terms and conditions page is available" do
    request = get("/terms_and_conditions")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test contact page is available" do
    request = get("/contact")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

  test "test sitemap is available" do
    request = get("/sitemap")
    response = UM.Web.AboutController.handle_request(request, [])
    assert 200 == response.status
  end

end
