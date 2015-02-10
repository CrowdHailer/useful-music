require_relative '../test_config'

class ItemsControllerTest < MyRecordTest
  include ControllerTesting

  def app
    ItemsController
  end

  def test_new_page_is_available
    record = create :piece_record
    assert_ok get "/new?piece_id=#{record.id}"
  end

  def test_can_create_new_item
    skip
    piece_record = create :piece_record
    post '/', :item => attributes_for(:item_record).merge(:piece => piece_record.id)
    ap last_response.status
    assert_equal '/items', last_response.location
  end
end
