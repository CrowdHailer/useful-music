Sequel.migration do
  up do
    alter_table(:pieces) do
      add_column :levels, String
    end
  end

  down do
    alter_table(:pieces) do
      drop_column :levels
    end
  end
end
