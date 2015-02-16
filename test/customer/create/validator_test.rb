require_relative '../../test_config'

class Customer
  class Create
    class ValidatorTest < MiniTest::Test
      def validator
        @validator ||= Validator.new
      end

      def teardown
        @validator = nil
      end

      def test_is_invalid_without_first_name
        # TODO length of name
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:first_name), 'is not present'
      end

      def test_is_invalid_without_last_name
        # TODO length of name
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:last_name), 'is not present'
      end

      def test_is_invalid_without_email
        # TODO email format
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:email), 'is not present'
      end

      def test_is_invalid_without_password
        # TODO min and max length
        # TODO confirmation
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:password), 'is not present'
      end

      def test_is_invalid_without_country
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:country), 'is not present'
      end
    end
  end
end
