require_relative '../test_config'

class Piece
  class RecordTest < MiniTest::Test
    def test_requires_catalogue_number
      assert_raises Sequel::NotNullConstraintViolation do
        Record.create
      end
    end
  end
end
