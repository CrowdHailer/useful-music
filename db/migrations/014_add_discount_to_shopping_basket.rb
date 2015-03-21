Sequel.migration do
  up do
    alter_table(:shopping_baskets) do
      add_foreign_key :discount_id, :discounts, :type => :varchar
    end
  end

  down do
    alter_table(:shopping_baskets) do
      drop_foreign_key :discount_id
    end
  end
end
