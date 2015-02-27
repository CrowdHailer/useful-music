require_relative '../../test_config'

class Session
  class Create
    class ValidatorTest < MiniTest::Test
      def validator
        @validator ||= Validator.new
      end

      def teardown
        @validator = nil
      end

      def test_is_invalid_without_email
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:email), 'is not present'
      end

      def test_is_invalid_email_with_no_at
        refute validator.valid? OpenStruct.new :email => 'this'
        assert_includes validator.errors.on(:email), 'is not valid'
      end

      def test_is_invalid_email_with_2_at
        refute validator.valid? OpenStruct.new :email => 'a@@a'
        assert_includes validator.errors.on(:email), 'is not valid'
      end

      def test_is_invalid_without_password
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:password), 'is not present'
      end

      def test_is_invalid_with_short_password
        refute validator.valid? OpenStruct.new :password => 'a'
        assert_includes validator.errors.on(:password), 'is shorter than 2 characters'
      end

      def test_is_invalid_with_long_password
        refute validator.valid? OpenStruct.new :password => 'a' * 56
        assert_includes validator.errors.on(:password), 'is longer than 55 characters'
      end
    end
  end
end
