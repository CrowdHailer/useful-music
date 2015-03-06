class Catalogue
  class Search
    include Virtus.model

    attribute :page, Integer
    attribute :page_size, Integer
    attribute :solo, Boolean
    attribute :solo_with_accompaniment, Boolean
    attribute :duet, Boolean
    attribute :trio, Boolean
    attribute :quarter, Boolean
    attribute :larger_ensembles, Boolean
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

    def categories
      result = []
      [:solo,
      :solo_with_accompaniment,
      :duet,
      :trio,
      :quarter,
      :larger_ensembles].each do |category|
        result = result << category if public_send category
      end
      result
    end

    def levels
      result = []
      [:beginner,
      :intermediate,
      :advanced,
      :professional].each do |level|
        result = result << level if public_send level
      end
      result
    end

    def instruments
      result = []
      [:piano,
      :recorder,
      :flute,
      :oboe,
      :clarineo,
      :clarinet,
      :basson,
      :saxophone,
      :trumpet,
      :violin,
      :viola,
      :percussion].each do |instrument|
        result = result << instrument if public_send instrument
      end
      result
    end

    def page
      super || 1
    end

    def page_size
      super || 10
    end

    def to_hash
      {
        :categories => categories,
        :levels => levels,
        :instruments => instruments,
        :page => page,
        :page_size => page_size
      }
    end

    delegate :each, :to => :to_hash
  end

end
