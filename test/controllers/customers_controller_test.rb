require_relative '../test_config'

class CustomersControllerTest < MyRecordTest
  include ControllerTesting

  def app
    CustomersController
  end

  def test_index_page_is_available
    create :customer_record, :email => 'test@example.com'
    assert_ok get '/'
    assert_includes last_response.body, 'test@example.com'
  end

  def test_new_page_is_available
    assert_ok get '/new'
  end
end
