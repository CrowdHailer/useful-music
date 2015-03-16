Sequel.migration do
  up do
    alter_table(:orders) do
      drop_constraint :orders_shopping_basket_id_key
    end
  end

  down do
    alter_table(:orders) do
      add_unique_constraint :shopping_basket_id
    end
  end
end
