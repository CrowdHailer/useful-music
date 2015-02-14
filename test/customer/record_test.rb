require_relative '../test_config'

class Cusomter
  class RecordTest < MyRecordTest
    def test_has_an_id
      record = create :customer_record
      # Checks id has non negligable length
      assert_match(/.{8}/, record.id)
    end

    def test_requires_first_name
      err = assert_raises Sequel::NotNullConstraintViolation do
        create :customer_record, :first_name => nil
      end
      assert_match(/first_name/, err.message)
    end
  end
end
