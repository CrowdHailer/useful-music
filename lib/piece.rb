require_relative './base_entity'

class Piece < BaseEntity
  entry_accessor  :id,
                  :title,
                  :sub_heading,
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
                    :basson,
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

end
