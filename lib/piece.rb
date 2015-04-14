
class Piece < Errol::Entity
  require_relative './piece/record'
  def self.repository
    Catalogue
  end

  entry_accessor  :id,
                  :title,
                  :sub_heading,
                  :level_overview,
                  :description,
                  :notation_preview,
                  :audio_preview,
                  :cover_image,
                  :print_link,
                  :print_title,
                  :weezic_link,
                  :meta_description,
                  :meta_keywords

  boolean_accessor  :beginner,
                    :intermediate,
                    :advanced,
                    :professional,
                    :solo,
                    :solo_with_accompaniment,
                    :duet,
                    :trio,
                    :quartet,
                    :larger_ensembles,
                    :collection,
                    :piano,
                    :recorder,
                    :flute,
                    :oboe,
                    :clarineo,
                    :clarinet,
                    :bassoon,
                    :saxophone,
                    :trumpet,
                    :violin,
                    :viola,
                    :percussion

  def items
    record.item_records.map{ |r| Item.new r }
  end

  def catalogue_number
    "UD#{record.id}" if record.id
  end

  def product_name
    "#{title} - #{sub_heading}"
  end

  def categories
    [:solo,
    :solo_with_accompaniment,
    :duet,
    :trio,
    :quartet,
    :larger_ensembles].select do |category|
      public_send "#{category}?"
    end
  end

  def instruments
    [:piano,
    :recorder,
    :flute,
    :oboe,
    :clarineo,
    :clarinet,
    :bassoon,
    :saxophone,
    :trumpet,
    :violin,
    :viola,
    :percussion].select do |instrument|
      public_send "#{instrument}?"
    end
  end

  def levels
    [:beginner,
    :intermediate,
    :advanced,
    :professional].select do |level|
      public_send "#{level}?"
    end
  end

end
