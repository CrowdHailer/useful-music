# require_relative './base_entity'

class Item < Errol::Entity
  require_relative './item/record'
  def self.repository
    Items
  end
  
  entry_accessor  :name,
                  :initial_price,
                  :discounted_price,
                  :asset

  def piece
    Piece.new record.piece_record if record.piece_record
  end

  def piece=(piece)
    record.piece_record = piece.record
  end

  def subsequent_price
    discounted_price || initial_price
  end

  def multibuy_discount?
    !!discounted_price
  end

  def price_for(n)
    initial_price + subsequent_price * (n-1)
  end

end
