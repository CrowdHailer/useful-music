require_relative './repository'

class Catalogue < Errol::Repository
  class Search
    include Virtus.model

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

    def to_hash
      {
        :categories => categories,
        :levels => levels,
        :instruments => instruments
      }
    end
  end

  # default :title, nil
  # default :levels, []
  # default :page, 1
  # default :page_size, 20

  class << self

    def [](catalogue_number)
      super catalogue_number[/\d+/]
    end

    def levels(*levels, **options)
      all options.merge(:levels => levels)
    end
  end

  def dataset
    val = super

    # val = levels_filter(val) if levels.count > 0
    levels = query.levels
    if levels.count > 0
      levels.each_with_index do |level, i|
        val = i == 0 ? val.where(level) : val.or(level)
      end
    end

    categories = query.categories
    if categories.count > 0
      categories.each_with_index do |category, i|
        val = i == 0 ? val.where(category) : val.or(category)
      end
    end

    instruments = query.instruments
    if instruments.count > 0
      instruments.each_with_index do |instrument, i|
        val = i == 0 ? val.where(instrument) : val.or(instrument)
      end
    end

    val = val.where(:title => query.title) if query.title
    val
  end

  def wrap(record)
    Piece.new(record)
  end

end
