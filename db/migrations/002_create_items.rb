Sequel.migration do
  up do
    create_table(:items) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :name, :null => false
      Integer :initial_price, :null => false
      Integer :discounted_price
      String :asset, :null => false
      foreign_key :piece_id, :pieces, :null => false
    end
  end

  down do
    drop_table(:items)
  end
end
