require_relative '../test_config'

class Basket
  class RecordTest < MyRecordTest
    def test_can_have_purchase_records
      record = create :shopping_basket_record
      record.add_purchase_record create(:purchase_record)
      assert record.purchase_records
    end
  end
end
