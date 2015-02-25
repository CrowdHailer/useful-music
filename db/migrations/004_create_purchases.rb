Sequel.migration do
  up do
    create_table(:purchases) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      Integer :quantity, :null => false
      foreign_key :item_id, :items, :type => :varchar, :null => false
      foreign_key :shopping_basket_id, :shopping_baskets, :type => :varchar, :null => false
      unique [:shopping_basket_id, :item_id], :name => :shopping_basket_item_groups
    end
  end

  down do
    drop_table(:purchases)
  end
end
