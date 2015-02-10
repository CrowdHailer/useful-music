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
end
