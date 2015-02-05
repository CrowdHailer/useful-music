Sequel.migration do
  up do
    create_table(:pieces) do
      primary_key :catalogue_number, :type => :integer, :auto_increment => false, :unique => true
    end
  end

  down do
    drop_table(:pieces)
  end
end
