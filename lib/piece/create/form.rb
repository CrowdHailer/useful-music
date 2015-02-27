class Piece
  class Create
    class Form
      # TODO untested because admin control only
      include Virtus.model

      attribute :id, Integer
      attribute :title, String
      attribute :sub_heading, String
      attribute :description, String
      attribute :category, String
      attribute :beginner, Boolean
      attribute :intermediate, Boolean
      attribute :advanced, Boolean
      attribute :professional, Boolean
      attribute :piano, Boolean
      attribute :recorder, Boolean
      attribute :flute, Boolean
      attribute :oboe, Boolean
      attribute :clarineo, Boolean
      attribute :clarinet, Boolean
      attribute :basson, Boolean
      attribute :saxophone, Boolean
      attribute :trumpet, Boolean
      attribute :violin, Boolean
      attribute :viola, Boolean
      attribute :percussion, Boolean
      attribute :notation_preview, Hash
      attribute :audio_preview, Hash
      attribute :cover_image, Hash
      attribute :print_version, String
      attribute :weezic_version, String
      attribute :meta_description, String
      attribute :meta_keywords, String
    end
  end
end
