Sequel.migration do
  up do
    alter_table(:pieces) do
      add_column :level_overview, String
    end
  end

  down do
    alter_table(:pieces) do
      drop_column :level_overview
    end
  end
end
