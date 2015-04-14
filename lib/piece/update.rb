class Piece
  class Update
    class Form
      # untested because admin control only
      include Virtus.model

      attribute :title, String
      attribute :sub_heading, String
      attribute :level_overview, String
      attribute :description, String
      attribute :solo, String
      attribute :solo_with_accompaniment, String
      attribute :duet, String
      attribute :trio, String
      attribute :quartet, String
      attribute :larger_ensembles, String
      attribute :collection, String
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
      attribute :bassoon, Boolean
      attribute :saxophone, Boolean
      attribute :trumpet, Boolean
      attribute :violin, Boolean
      attribute :viola, Boolean
      attribute :percussion, Boolean
      attribute :notation_preview, Hash
      attribute :audio_preview, Hash
      attribute :cover_image, Hash
      attribute :print_link, String
      attribute :print_title, String
      attribute :weezic_link, String
      attribute :meta_description, String
      attribute :meta_keywords, String

      delegate :each, :to => :to_hash
    end
  end
end
