require_relative '../../test_config'

class Customer
  class Update
    class ValidatorTest < MiniTest::Test
      def validator
        @validator ||= Validator.new
      end

      def teardown
        @validator = nil
      end

      def test_is_invalid_without_first_name
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:first_name), 'is not present'
      end

      def test_is_invalid_with_short_first_name
        refute validator.valid? OpenStruct.new :first_name => 'a'
        assert_includes validator.errors.on(:first_name), 'is shorter than 2 characters'
      end

      def test_is_invalid_with_long_first_name
        refute validator.valid? OpenStruct.new :first_name => 'a' * 27
        assert_includes validator.errors.on(:first_name), 'is longer than 26 characters'
      end

      def test_is_invalid_without_last_name
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:last_name), 'is not present'
      end

      def test_is_invalid_with_short_last_name
        refute validator.valid? OpenStruct.new :last_name => 'a'
        assert_includes validator.errors.on(:last_name), 'is shorter than 2 characters'
      end

      def test_is_invalid_with_long_last_name
        refute validator.valid? OpenStruct.new :last_name => 'a' * 27
        assert_includes validator.errors.on(:last_name), 'is longer than 26 characters'
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

      def test_is_invalid_without_country
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:country), 'is not present'
      end

    end
  end
end
