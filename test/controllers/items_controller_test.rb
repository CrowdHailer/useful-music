require_relative '../test_config'

class ItemsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    ItemsController
  end

  def test_new_page_is_available
    record = create :piece_record
    assert_ok get "/new?piece_id=#{record.id}"
    assert_includes last_response.body, "UD#{record.id}"
  end

  def test_can_create_new_item
    skip
    piece_record = create :piece_record
    post '/', :item => attributes_for(:item_record).merge(:piece => piece_record.id)
    assert_match /pieces\/UD#{piece_record.id}/, last_response.location
  end

  def test_edit_page_is_available
    skip
    record = create :item_record
    assert_ok get "/#{record.id}/edit"
  end

  def test_can_update_item
    skip
    skip
    record = create :item_record, :name => 'test'
    put "/#{record.id}", :item => {:name => 'test', :initial_price => 41, :subsequent_price => 21}
    assert_match /pieces\/UD\d{3}/, last_response.location
    assert_equal 41, Item::Record.last.initial_price
  end

  def test_can_delete_an_item
    record = create :item_record
    delete "/#{record.id}"
    assert_empty Item::Record
    assert_match /pieces\/UD\d{3}/, last_response.location
  end
end
