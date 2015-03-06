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

  def test_search_redirects_to_show_page
    create :piece_record, :id => 100
    get '/search', {:search => '100'}
    assert last_response.redirect?
    assert_equal '/pieces/UD100', last_response.location
  end

  def test_search_redirects_to_show_page
    get '/search', {:search => '100'}
    assert_equal 'Could not find piece requested', flash['error']
    assert last_response.redirect?
    assert_equal '/pieces', last_response.location
  end

  def test_show_page_is_available
    record = create :piece_record, :id => 123
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
  end

  def test_show_page_is_available_without_cover_image_or_audio_preview
    record = create :piece_record, :id => 123, :cover_image => nil, :audio_preview => nil
    assert_ok get "/UD#{record.id}"
    assert_includes last_response.body, 'UD123'
  end

  def test_from_show_page_redirected_if_no_piece
    get "/UD000"
    assert_equal 'Piece not found', flash['error']
    assert last_response.redirect?
  end

  def test_edit_page_is_available_to_admin
    record = create :piece_record, :id => 123
    assert_ok get "/UD#{record.id}/edit", {}, {'rack.session' => { :user_id => admin.id }}
    assert_includes last_response.body, 'UD123'
  end

  def test_edit_page_is_unavailable_to_customer
    record = create :piece_record, :id => 123
    get "/UD#{record.id}/edit", {}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_redirected_from_edit_if_no_piece
    get "/UD000/edit", {}, {'rack.session' => { :user_id => admin.id }}
    assert last_response.redirect?
  end

  def test_admin_can_update_a_piece
    record = create :piece_record, :id => 123
    put '/UD123', {:piece => attributes_for(:piece_record, :id => record.id, :title => 'All change')}, {'rack.session' => { :user_id => admin.id }}
    assert_equal 'Piece updated', flash['success']
    assert_equal 'All change', Piece::Record[123].title
    assert_equal '/UD123', last_response.location
  end

  def test_customer_cant_update_a_piece
    record = create :piece_record, :id => 123
    put '/UD123', {:piece => attributes_for(:piece_record, :id => record.id, :title => 'All change')}, {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end

  def test_destroy_action_redirects_to_index
    record = create :piece_record
    delete "/UD#{record.id}", {}, {'rack.session' => { :user_id => admin.id }}
    assert_empty Piece::Record
    assert_equal '/', last_response.location
  end

  def test_destroys_associated_items
    item_record = create :item_record
    delete "/UD#{item_record.piece_record.id}", {}, {'rack.session' => { :user_id => admin.id }}
    assert_empty Item::Record
  end

  def test_customer_cant_delete_a_piece
    record = create :piece_record, :id => 123
    delete "/UD#{record.id}", {'rack.session' => { :user_id => customer.id }}
    assert_equal 'Access denied', flash['error']
    assert last_response.redirect?
  end
end
