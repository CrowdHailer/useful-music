require_relative '../../test_config'

class Customer
  class UpdatePassword
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

      def test_obtains_current_password
        form = Form.new :current_password => 'current_password'
        assert_equal 'current_password', form.current_password
      end

      def test_strips_whitespace_from_current_password
        form = Form.new :current_password => '   current_password  '
        assert_equal 'current_password', form.current_password
      end

      def test_silent_if_current_password_not_supplied
        form = Form.new
        assert_equal '', form.password
      end

      def test_password_not_confirmed_if_different
        form = Form.new :password => 'Password', :password_confirmation => 'other'
        assert_equal false, form.password_confirmed?
      end

      def test_password_confirmed_when_same
        form = Form.new :password => 'password', :password_confirmation => 'password'
        assert_equal true, form.password_confirmed?
      end

    end
  end
end
