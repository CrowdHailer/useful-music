require_relative '../test_config'

class Piece
  class RecordTest < MiniTest::Test
    def values

    end
    def test_can_save_a_catalogue_number
      assert_silent do
        skip
        r = Record.new :catalogue_number => 'UD001'
        r.save
      end
    end
    def test_requires_catalogue_number
      assert_raises Sequel::NotNullConstraintViolation do
        Record.create
      end
    end
  end
end
