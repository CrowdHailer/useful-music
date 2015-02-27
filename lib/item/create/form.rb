class Item
  class Create
    class Form
      include Virtus.model

      attribute :piece, Integer
      attribute :name, String
      attribute :initial_price, Float
      attribute :discounted_price, Float
      attribute :asset, Hash

      delegate :each, :to => :to_hash

      def name
        (super || '').strip
      end

      def piece
        record = Piece::Record[super]
        Piece.new(record) if record
      end

      def initial_price
        decimal = super
        Money.new(decimal * 100) if decimal.is_a?(Float)
      end

      def discounted_price
        decimal = super
        Money.new(decimal * 100) if decimal.is_a?(Float)
      end
    end
  end
end
