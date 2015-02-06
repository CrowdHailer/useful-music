
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
      attribute :notation_preview, String
      attribute :audio_preview, String
      attribute :cover_image, String

      # mount_uploader
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
