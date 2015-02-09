Sequel.migration do
  up do
    create_table(:purchases) do
      primary_key :id
      Integer :quantity, :null => false
    end
  end

  down do
    drop_table(:purchases)
  end
end
