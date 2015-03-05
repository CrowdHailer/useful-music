require_relative '../test_config'

class ItemsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    ItemsController
  end

  def test_new_page_is_available_to_admin
    record = create :piece_record
    assert_ok get "/new?piece_id=#{record.id}", {}, {'rack.session' => { :user_id => admin.id }}
    assert_includes last_response.body, "UD#{record.id}"
  end

  def test_new_page_is_unavailable_to_customer
    record = create :piece_record
    get "/new?piece_id=#{record.id}", {}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_no_new_page_for_missing_piece_to_admin
    assert_raises Errol::Repository::RecordMissing do
      get "/new?piece_id=100", {}, {'rack.session' => { :user_id => admin.id }}
    end
  end

  def test_can_create_item_as_admin
    piece_record = create :piece_record
    post '/', {:item => attributes_for(:item_record).merge(:piece => piece_record.id)}, {'rack.session' => { :user_id => admin.id }}
    assert_match(/pieces\/UD#{piece_record.id}/, last_response.location)
  end

  def test_cant_create_item_as_customer
    piece_record = create :piece_record
    post '/', {:item => attributes_for(:item_record).merge(:piece => piece_record.id)}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_create_item_with_missing_data_as_admin
    piece_record = create :piece_record
    post '/', {:item => {}.merge(:piece => piece_record.id)}, {'rack.session' => { :user_id => admin.id }}
    assert_equal '/pieces', last_response.location
  end

  def test_create_item_with_invalid_data_as_admin
    piece_record = create :piece_record
    post '/', {:item => attributes_for(:item_record).merge(:piece => piece_record.id, :initial_price => -1)}, {'rack.session' => { :user_id => admin.id }}
    assert_equal '/pieces', last_response.location
  end

  def test_edit_page_is_availableto_admin
    record = create :item_record
    assert_ok get "/#{record.id}/edit", {}, {'rack.session' => { :user_id => admin.id }}
  end

  def test_edit_page_is_unavailableto_admin
    record = create :item_record
    get "/#{record.id}/edit", {}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_can_update_item_as_admin
    record = create :item_record, :name => 'test'
    put "/#{record.id}", {:item => {:name => 'test2'}}, {'rack.session' => { :user_id => admin.id }}
    assert_match /pieces\/UD\d{3}/, last_response.location
    assert_equal 'test2', Item::Record.last.name
  end

  def test_cant_update_item_as_customer
    record = create :item_record, :name => 'test'
    put "/#{record.id}", {:item => {:name => 'test2'}}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_can_delete_an_item_as_admin
    record = create :item_record
    delete "/#{record.id}", {}, {'rack.session' => { :user_id => admin.id }}
    assert_empty Item::Record
    assert_match /pieces\/UD\d{3}/, last_response.location
  end

  def test_can_delete_an_item_as_customer
    record = create :item_record
    delete "/#{record.id}", {}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end
end
