require_relative '../test_config'

class Basket
  class RecordTest < MyRecordTest
    def test_can_have_purchase_records
      skip
      record = create :basket_record
      ap record.purchase_records
    end
  end
end
