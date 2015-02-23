require_relative '../../test_config'

class Customer
  class Create
    class FormTest < MiniTest::Test
      def test_obtains_first_name
        form = Form.new :first_name => 'Will'
        assert_equal 'Will', form.first_name
      end

      def test_capitalises_first_name
        form = Form.new :first_name => 'will'
        assert_equal 'Will', form.first_name
      end

      def test_strips_whitespace_from_first_name
        form = Form.new :first_name => '   Mike  '
        assert_equal 'Mike', form.first_name
      end

      def test_silent_if_first_name_not_supplied
        form = Form.new
        assert_equal '', form.first_name
      end

      def test_obtains_last_name
        form = Form.new :last_name => 'Smith'
        assert_equal 'Smith', form.last_name
      end

      def test_capitalises_last_name
        form = Form.new :last_name => 'will'
        assert_equal 'Will', form.last_name
      end

      def test_strips_whitespace_from_last_name
        form = Form.new :last_name => '   Mike  '
        assert_equal 'Mike', form.last_name
      end

      def test_silent_if_last_name_not_supplied
        form = Form.new
        assert_equal '', form.last_name
      end

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

      def test_obtains_country_when_known
        form = Form.new :country => 'GB'
        assert_equal Country.new('gb'), form.country
        ap form.country.alpha2
      end

      def test_nil_country_when_unknown
        form = Form.new :country => 'ZZ'
        assert_nil form.country
      end

      def test_strips_whitespace_from_password_confirmation
        form = Form.new :password_confirmation => '   password  '
        assert_equal 'password', form.password_confirmation
      end

      def test_silent_if_password_confirmation_not_supplied
        form = Form.new
        assert_equal '', form.password_confirmation
      end

      def test_obtains_agreement_when_checked
        form = Form.new :terms_agreement => 'on'
        assert form.terms_agreed?
      end

      def test_does_not_obtain_agreement_when_unchecked_checked
        form = Form.new :terms_agreement => 'other'
        refute form.terms_agreed?
      end
    end
  end
end
