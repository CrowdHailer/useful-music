Sequel.migration do
  up do
    extension(:constraint_validations)

    DB.create_constraint_validations_table

    create_table(:pieces) do
      primary_key :id, :type => :integer, :auto_increment => false, :unique => true
      String :title, :null => false
      String :sub_heading, :null => false
      String :description, :null => false
      # String :category, :null => false
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
      String :cover_image, :null => false
      String :print_link
      String :print_title
      String :weezic_link
      String :meta_description
      String :meta_keywords
    end
  end

  down do
    extension(:constraint_validations)

    drop_table(:pieces)

    DB.drop_constraint_validations_table
  end
end
