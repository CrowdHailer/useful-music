require_relative '../../test_config'

class PasswordReset
  class Update
    class ValidatorTest < MiniTest::Test
      def validator
        @validator ||= Validator.new
      end

      def teardown
        @validator = nil
      end

      def test_is_invalid_with_short_password
        refute validator.valid? OpenStruct.new :password => 'a'
        assert_includes validator.errors.on(:password), 'is shorter than 2 characters'
      end

      def test_is_invalid_with_long_password
        refute validator.valid? OpenStruct.new :password => 'a' * 56
        assert_includes validator.errors.on(:password), 'is longer than 55 characters'
      end

      def test_is_invalid_without_confirmed_password
        refute validator.valid? OpenStruct.new :password => 'password', :password_confirmation => 'passwordz'
        assert_includes validator.errors.on(:password_confirmation), 'does not match'
      end
    end
  end
end
