require_relative '../test_config'

class Piece
  class EntityTest < MyRecordTest
    def piece
      @piece ||= Piece.new record
    end

    def record
      @record ||= OpenStruct.new
    end

    def teardown
      @piece = nil
      @record = nil
    end

    def test_generates_catalogue_number
      record.id = 213
      assert_equal 'UD213', piece.catalogue_number
    end

    def test_returns_nil_catalogue_number
      assert_nil piece.catalogue_number
    end

    def test_has_a_product_name
      record.title = 'Title'
      record.sub_heading = 'sub heading'
      assert_equal 'Title - sub heading', piece.product_name
    end

    ################# Associations #####################

    def test_has_items
      @record = create :item_record
      assert_equal Item, Piece.new(record.piece_record).items.first.class
    end

    ################# Archive #####################

    def test_can_access_title
      record.title = 'Garden Piece'
      assert_equal 'Garden Piece', piece.title
    end

    def test_can_set_title
      piece.title = 'Garden Piece'
      assert_equal 'Garden Piece', record.title
    end

    def test_can_access_sub_heading
      record.sub_heading = 'oboe and keyboard'
      assert_equal 'oboe and keyboard', piece.sub_heading
    end

    def test_can_set_sub_heading
      piece.sub_heading = 'oboe and keyboard'
      assert_equal 'oboe and keyboard', record.sub_heading
    end

    def test_can_access_description
      record.description = 'Lots of interesting information'
      assert_equal 'Lots of interesting information', piece.description
    end

    def test_can_set_description
      piece.description = 'Lots of interesting information'
      assert_equal 'Lots of interesting information', record.description
    end

    def test_can_access_notation_preview
      record.notation_preview = :file
      assert_equal :file, piece.notation_preview
    end

    def test_can_set_notation_preview
      piece.notation_preview = :file
      assert_equal :file, record.notation_preview
    end

    def test_can_access_audio_preview
      record.audio_preview = :file
      assert_equal :file, piece.audio_preview
    end

    def test_can_set_audio_preview
      piece.audio_preview = :file
      assert_equal :file, record.audio_preview
    end

    def test_can_access_cover_image
      record.cover_image = :file
      assert_equal :file, piece.cover_image
    end

    def test_can_set_cover_image
      piece.cover_image = :file
      assert_equal :file, record.cover_image
    end

    [:beginner, :intermediate, :advanced, :professional].each do |bool_entry|
      define_method "test_can_access_#{bool_entry}" do
        record.public_send "#{bool_entry}=", true
        assert piece.public_send "#{bool_entry}?"
      end

      define_method "test_can_set_#{bool_entry}" do
        piece.public_send "#{bool_entry}=", true
        assert_equal true, record.public_send("#{bool_entry}")
      end
    end

    [:piano, :recorder, :flute, :oboe, :clarineo, :clarinet, :basson, :saxophone, :trumpet, :violin, :viola, :percussion].each do |bool_entry|
      define_method "test_can_access_#{bool_entry}" do
        record.public_send "#{bool_entry}=", true
        assert piece.public_send "#{bool_entry}?"
      end

      define_method "test_can_set_#{bool_entry}" do
        piece.public_send "#{bool_entry}=", true
        assert_equal true, record.public_send("#{bool_entry}")
      end
    end

    [:solo, :solo_with_accompaniment, :duet, :trio, :quartet, :larger_ensembles, :collection].each do |bool_entry|
      define_method "test_can_access_#{bool_entry}" do
        record.public_send "#{bool_entry}=", true
        assert piece.public_send "#{bool_entry}?"
      end

      define_method "test_can_set_#{bool_entry}" do
        piece.public_send "#{bool_entry}=", true
        assert_equal true, record.public_send("#{bool_entry}")
      end
    end

    def test_can_access_print_link
      record.print_link = 'Description'
      assert_equal 'Description', piece.print_link
    end

    def test_can_set_print_link
      piece.print_link = 'Description'
      assert_equal 'Description', record.print_link
    end

    def test_can_access_print_title
      record.print_title = 'Description'
      assert_equal 'Description', piece.print_title
    end

    def test_can_set_print_title
      piece.print_title = 'Description'
      assert_equal 'Description', record.print_title
    end

    def test_can_access_weezic_link
      record.weezic_link = 'Description'
      assert_equal 'Description', piece.weezic_link
    end

    def test_can_set_weezic_link
      piece.weezic_link = 'Description'
      assert_equal 'Description', record.weezic_link
    end

    def test_can_access_meta_description
      record.meta_description = 'Description'
      assert_equal 'Description', piece.meta_description
    end

    def test_can_set_meta_description
      piece.meta_description = 'Description'
      assert_equal 'Description', record.meta_description
    end

    def test_can_access_meta_keywords
      record.meta_keywords = 'Music players'
      assert_equal 'Music players', piece.meta_keywords
    end

    def test_can_set_meta_keywords
      piece.meta_keywords = 'Music players'
      assert_equal 'Music players', record.meta_keywords
    end
  end
end
