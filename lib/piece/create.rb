class Item
  class Create
    class Form
      # TODO untested because admin control only
      include Virtus.model

      attribute :name, String
      attribute :initial_price, Float
      attribute :subsequent_price, Float
      attribute :asset, Hash
    end
  end
end
class Piece
  class Create
    class Form
      # TODO untested because admin control only
      include Virtus.model

      attribute :catalogue_number, Integer
      attribute :title, String
      attribute :sub_heading, String
      attribute :description, String
      attribute :category, String
      attribute :notation_preview, Hash
      attribute :audio_preview, Hash
      attribute :cover_image, Hash
      attribute :items, Array[Item]
    end
  end
end

class Piece
  class Create
    class Validator
      # Todo untested because admin control
      include Veto.validator

      validates :title, :presence => true
    end
  end
end
