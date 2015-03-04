require_relative '../test_config'

class DiscountsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    DiscountsController
  end

  def test_index_page_is_available_to_admin
    assert_ok get '/', {}, {'rack.session' => { :user_id => admin.id }}
    # assert_includes last_response.body, admin.email
  end

  def test_index_page_is_not_available_to_non_admin
    get '/', {}, {'rack.session' => { :user_id => interloper.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_new_page_is_available_to_admin
    assert_ok get '/new', {}, {'rack.session' => { :user_id => admin.id }}
    # assert_includes last_response.body, admin.email
  end

  def test_new_page_is_not_available_to_non_admin
    get '/new', {}, {'rack.session' => { :user_id => interloper.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_can_create_discount_if_admin
    post '/', {:discount => attributes_for(:discount_record)}, {'rack.session' => { :user_id => admin.id }}
    assert_equal 'Discount Created', flash['success']
    assert last_response.redirect?
    # TODO change to repository
    refute_empty Discount::Record
  end

  def test_cant_create_discount_if_not_admin
    post '/', {:discount => attributes_for(:discount_record)}, {'rack.session' => { :user_id => interloper.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_edit_page_is_available_to_admin
    discount_record = create :discount_record
    assert_ok get "/#{discount_record.id}/edit", {}, {'rack.session' => { :user_id => admin.id }}
    # assert_includes last_response.body, admin.email
  end

  def test_can_update_as_admin
    discount_record = create :discount_record
    put "/#{discount_record.id}", {:discount => attributes_for(:discount_record).merge({:code => 'NEW21'})}, {'rack.session' => { :user_id => admin.id }}
    assert_equal 'NEW21', discount_record.reload.code
  end

end
