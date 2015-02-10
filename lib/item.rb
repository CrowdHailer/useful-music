require_relative './base_entity'

class Item < BaseEntity
  entry_accessor  :name,
                  :initial_price,
                  :subsequent_price,
                  :asset

  def piece
    Piece.new record.piece_record if record.piece_record
  end

  def piece=(piece)
    record.piece_record = piece.record
  end

  # TODO clear possible price of method
  # def subsequent_price
  #   record.subsequent_price || record.initial_price
  # end
  #
  # def subsequent_price=(subsequent_price)
  #   record.subsequent_price = subsequent_price
  # end

end
