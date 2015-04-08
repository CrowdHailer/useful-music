Sequel.migration do
  up do
    alter_table(:orders) do
      add_column :completed_at, DateTime
    end
  end

  down do
    alter_table(:orders) do
      drop_column :completed_at
    end
  end
end
