Sequel.migration do
  up do
    extension(:constraint_validations)

    create_table(:items) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :name, :null => false
      Integer :initial_price, :null => false
      Integer :discounted_price
      String :asset, :null => false
      foreign_key :piece_id, :pieces, :null => false
      validate do
        includes 0...100000, :initial_price, :name => 'initial_price_limit'
        includes 0...100000, :discounted_price, :name => 'discounted_price_limit'
      end
    end
  end

  down do
    drop_table(:items)
  end
end
