require_relative '../test_config'

class Order
  class RecordTest < MyRecordTest
    def test_has_an_id
      record = create :order_record
      # Checks id has non negligable length
      assert_match(/.{8}/, record.id)
    end
  end
end
