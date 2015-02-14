require_relative '../../test_config'

class Customer
  class Create
    class FormTest < MiniTest::Test
      def test_obtains_first_name
        form = Form.new :first_name => 'Will'
        assert_equal 'Will', form.first_name
      end

      def test_obtains_last_name
        form = Form.new :last_name => 'Smith'
        assert_equal 'Smith', form.last_name
      end

      def test_obtains_email
        form = Form.new :email => 'test@example.com'
        assert_equal 'test@example.com', form.email
      end

      def test_obtains_password
        form = Form.new :password => 'password'
        assert_equal 'password', form.password
      end

      def test_obtains_country
        form = Form.new :country => 'uk'
        assert_equal 'uk', form.country
      end
    end
  end
end
