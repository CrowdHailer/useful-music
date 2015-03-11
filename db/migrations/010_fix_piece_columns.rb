Sequel.migration do
  up do
    alter_table(:pieces) do
      set_column_not_null :level_overview
      rename_column :basson, :bassoon
    end
  end

  down do
    alter_table(:pieces) do
      set_column_allow_null :level_overview
      rename_column :bassoon, :basson
    end
  end
end
