require_relative '../test_config'

class PiecesControllerTest < MyRecordTest
  include ControllerTesting

  def app
    PiecesController
  end

  def test_index_page_is_available
    create :piece_record, :id => 100
    assert_ok get '/'
    assert_includes last_response.body, 'UD100'
  end

  def test_new_page_is_available_to_admin
    assert_ok get '/new', {}, {'rack.session' => { :user_id => admin.id }}
  end

  def test_new_page_is_not_available_to_customers
    get '/new', {}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_can_create_piece_as_admin
    post '/', {:piece => attributes_for(:piece_record, :id => 212)}, {'rack.session' => { :user_id => admin.id }}
    assert_equal 212, Piece::Record.last.id
    assert_equal '/UD212', last_response.location
  end

  def test_cant_create_piece_as_customer
    post '/', {:piece => attributes_for(:piece_record, :id => 212)}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_show_page_is_available
    record = create :piece_record, :id => 123
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
  end

  def test_edit_page_is_available
    record = create :piece_record, :id => 123
    assert_ok get "/UD#{record.id}/edit"
    # assert_includes last_response.body, 'UD123'
  end

  def test_can_update_a_piece
    record = create :piece_record, :id => 123
    put '/UD123', :piece => attributes_for(:piece_record, :id => record.id, :title => 'All change')
    assert_equal 'All change', Piece::Record[123].title
    assert_equal '/UD123', last_response.location
  end

  def test_destroy_action_redirects_to_index
    record = create :piece_record
    delete "/UD#{record.id}"
    assert_empty Piece::Record
    assert_equal '/', last_response.location
  end

  def test_destroys_associated_items
    item_record = create :item_record
    delete "/UD#{item_record.piece_record.id}"
    assert_empty Item::Record
  end
end
