class Item
  class Create
    class Form
      include Virtus.model

      attribute :piece, Integer
      attribute :name, String
      attribute :initial_price, Integer
      attribute :subsequent_price, Integer
      attribute :asset, Hash
    end
  end
end
