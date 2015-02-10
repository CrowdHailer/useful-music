class Piece
  class Update
    class Form
      # TODO untested because admin control only
      include Virtus.model

      attribute :title, String
      attribute :sub_heading, String
      attribute :description, String
      attribute :category, String
      attribute :notation_preview, Hash
      attribute :audio_preview, Hash
      attribute :cover_image, Hash
    end
  end
end
