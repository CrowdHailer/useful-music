Sequel.migration do
  up do
    create_table(:purchases) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      Integer :quantity, :null => false
      foreign_key :item_id, :items, :null => false
      foreign_key :shopping_basket_id, :shopping_baskets, :null => false
    end
  end

  down do
    drop_table(:purchases)
  end
end
