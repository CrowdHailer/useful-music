Sequel.migration do
  up do
    create_table(:pieces) do
      primary_key :id
      String :title, :null=>false
    end
  end

  down do
    drop_table(:pieces)
  end
end
