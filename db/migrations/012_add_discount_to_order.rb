Sequel.migration do
  up do
    alter_table(:orders) do
      add_foreign_key :discount_id, :discounts, :type => :varchar
    end
  end

  down do
    alter_table(:orders) do
      drop_foreign_key :discount_id
    end
  end
end
