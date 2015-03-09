require_relative '../../test_config'

class Purchase
  class Create
    class ValidatorTest < MiniTest::Test
      def validator
        @validator ||= Validator.new
      end

      def teardown
        @validator = nil
      end

      def test_is_invalid_without_item
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:item), 'is not present'
      end

      def test_is_invalid_without_shopping_basket
        refute validator.valid? OpenStruct.new
        assert_includes validator.errors.on(:shopping_basket), 'is not present'
      end

      def test_is_invalid_with_zero_quantity
        refute validator.valid? OpenStruct.new :quantity => 0
        assert_includes validator.errors.on(:quantity), 'must be greater than 0'
      end

    end
  end
end
