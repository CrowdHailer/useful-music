Sequel.migration do
  up do
    alter_table(:orders) do
      rename_column :license, :licence
    end
  end

  down do
    alter_table(:orders) do
      rename_column :licence, :license
    end
  end
end
