require_relative '../../test_config'

class PasswordReset
  class Update
    class FormTest < MiniTest::Test
      def test_obtains_password
        form = Form.new :password => 'password'
        assert_equal 'password', form.password
      end

      def test_strips_whitespace_from_password
        form = Form.new :password => '   password  '
        assert_equal 'password', form.password
      end

      def test_silent_if_password_not_supplied
        form = Form.new
        assert_equal '', form.password
      end

      def test_silent_if_password_confirmation_not_supplied
        form = Form.new
        assert_equal '', form.password_confirmation
      end

      def test_checks_confirmation
        form = Form.new :password => 'password', :password_confirmation => 'password'
        assert form.password_confirmed?
      end
    end
  end
end
