require_relative '../../test_config'

class Session
  class Create
    class FormTest < MiniTest::Test
      def test_obtains_email
        form = Form.new :email => 'test@example.com'
        assert_equal 'test@example.com', form.email
      end

      def test_downcases_email
        form = Form.new :email => 'Test@ExamplE.com'
        assert_equal 'test@example.com', form.email
      end

      def test_strips_whitespace_from_email
        form = Form.new :email => '   test@example.com  '
        assert_equal 'test@example.com', form.email
      end

      def test_silent_if_email_not_supplied
        form = Form.new
        assert_equal '', form.email
      end

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
    end
  end
end
