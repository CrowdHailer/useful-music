Sequel.migration do
  up do
    create_table(:purchases) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      Integer :quantity, :null => false
      DateTime :created_at
      DateTime :updated_at

      foreign_key :item_id, :items, :type => :varchar, :null => false
      foreign_key :shopping_basket_id, :shopping_baskets, :type => :varchar, :null => false
      unique [:shopping_basket_id, :item_id], :name => :shopping_basket_item_groups
      validate do
        includes 1..100, :quantity, :name => 'purchase_quantity_limit'
      end
    end
  end

  down do
    drop_table(:purchases)
  end
end
