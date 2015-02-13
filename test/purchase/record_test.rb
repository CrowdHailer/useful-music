require_relative '../test_config'

class Purchase
  class RecordTest < MyRecordTest
    def test_can_have_quantity
      purchase_record = create :purchase_record, :quantity => 4
      assert_equal 4, purchase_record.quantity
    end

    def test_requires_quantity
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :quantity => nil
      end
      assert_match(/quantity/, err.message)
    end

    def test_can_have_item_record
      purchase_record = create :purchase_record
      assert purchase_record.item_record
    end

    def test_requires_item_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :item_record => nil
      end
      assert_match(/item_id/, err.message)
    end

    def test_can_have_shopping_basket_record
      purchase_record = create :purchase_record
      assert purchase_record.shopping_basket_record
    end

    def test_requires_shopping_basket_record
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :purchase_record, :shopping_basket_record => nil
      end
      assert_match(/shopping_basket_id/, err.message)
    end

    def test_requires_unique_basket_item_combination
      shopping_basket_record = create :shopping_basket_record
      item_record = create :item_record
      err = assert_raises Sequel::UniqueConstraintViolation do
        2.times do
          create :purchase_record,
            :item_record => item_record,
            :shopping_basket_record => shopping_basket_record
        end
      end
      assert_match(/shopping_basket_item_groups/, err.message)
    end
  end
end
