Sequel.migration do
  up do

    create_table(:pieces) do
      primary_key :id, :type => :integer, :auto_increment => false, :unique => true
      String :title, :null => false
      String :sub_heading, :null => false
      String :description, :null => false
      TrueClass :solo
      TrueClass :solo_with_accompaniment
      TrueClass :duet
      TrueClass :trio
      TrueClass :quartet
      TrueClass :larger_ensembles
      TrueClass :collection
      TrueClass :beginner
      TrueClass :intermediate
      TrueClass :advanced
      TrueClass :professional
      TrueClass :piano
      TrueClass :recorder
      TrueClass :flute
      TrueClass :oboe
      TrueClass :clarineo
      TrueClass :clarinet
      TrueClass :basson
      TrueClass :saxophone
      TrueClass :trumpet
      TrueClass :violin
      TrueClass :viola
      TrueClass :percussion
      String :notation_preview, :null => false
      String :audio_preview
      String :cover_image
      String :print_link
      String :print_title
      String :weezic_link
      String :meta_description
      String :meta_keywords
    end
  end

  down do
    drop_table(:pieces)
  end
end
