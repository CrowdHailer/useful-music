Sequel.migration do
  up do
    alter_table(:pieces) do
      add_column :jazz_head, TrueClass
    end
  end

  down do
    alter_table(:pieces) do
      drop_column :jazz_head
    end
  end
end
