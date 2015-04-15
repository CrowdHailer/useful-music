Sequel.migration do
  up do
    alter_table(:orders) do
      add_column :reminded_at, DateTime
    end
  end

  down do
    alter_table(:orders) do
      drop_column :reminded_at
    end
  end
end
