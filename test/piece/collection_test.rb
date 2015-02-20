require_relative '../test_config'

class Piece
  class RecordTest < MyRecordTest
    def test_filter_on_single_level
      record = create :piece_record, :beginner
      record = create :piece_record, :intermediate
      # ap Record.where(:piano => true).or(:flute => true).count
      Catalogue.all(:levels => [:beginner, :intermediate])
    end
  end
end
