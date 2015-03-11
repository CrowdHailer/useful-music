Sequel.migration do
  up do
    alter_table(:customers) do
      add_column :currency_preference, String
      add_foreign_key :shopping_basket_id, :shopping_baskets, :type => :varchar, :unique => true
    end
  end

  down do
    alter_table(:customers) do
      drop_column :currency_preference
      drop_foreign_key :shopping_basket_id
    end
  end
end
