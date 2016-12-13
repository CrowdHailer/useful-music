require_relative '../test_config'

class PasswordResetsControllerTest < MyRecordTest
  include ControllerTesting
  include MailerTesting


  def app
    Mail.defaults do
      delivery_method :test
    end
    PasswordResetsController
  end

  def test_can_reset_password
    email = customer.email
    token = customer.create_password_reset
    customer.record.save
    put "/#{token}", {:email => email, :customer => {
      :password => 'new',
      :password_confirmation => 'new'
    }}
    customer.record.reload
    assert_equal customer.password, 'new'
  end
end
