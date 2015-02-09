Sequel.migration do
  up do
    create_table(:purchases) do
      primary_key :id
      Integer :quantity, :null => false
      foreign_key :item_id, :items, :null => false
      foreign_key :basket_id, :baskets, :null => false
    end
  end

  down do
    drop_table(:purchases)
  end
end
