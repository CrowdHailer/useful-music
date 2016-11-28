defmodule UM.Web.AdminTest do
  use ExUnit.Case, async: true

  import Raxx.Test

  # This would be the header field but after the gateway we are not sending cookies
  # headers: [{"cookie", "raxx.session=admin"}]}
  test "index page is available to admin" do
    request = get("/", [{"um-user-id", "dummy-admin-id"}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 200
  end

  test "index page is forbidden to customer" do
    request = get("/", [{"um-user-id", "dummy-customer-id"}])
    response = UM.Web.Admin.handle_request(request, %{})
    assert response.status == 403
  end

  test "pieces page is available to admin" do
    request = get("/pieces", [{"um-user-id", "dummy-admin-id"}])
    response = UM.Web.Admin.handle_request(request, %{})
    # Check that the correct page is served
    assert response.status == 200
  end
end

# Left to expand Raxx.Test with similar semantics
# def test_index_page_is_available_to_admin
#   assert_ok get '/', {}, {'rack.session' => { :user_id => admin.id }}
# end
#
# def test_index_page_is_not_available_to_customer
#   get '/', {}, {'rack.session' => { :user_id => customer.id }}
#   assert_equal 'Access denied', flash['error']
#   assert last_response.redirect?
# end
#
# def test_guest_is_redirected_to_login
#   get '/', {}, {}
#   assert_equal 'Login required', flash['error']
#   assert_equal '/sessions/new?requested_path=/admin', last_response.location
# end
