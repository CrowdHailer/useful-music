Sequel.migration do
  up do
    create_table(:orders) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :state, :null => false

      DateTime :created_at
      DateTime :updated_at
      DateTime :last_login_at
      foreign_key :shopping_basket_id, :shopping_baskets, :unique => true, :null => false
      foreign_key :customer_id, :customers, :type => :varchar, :null => false
    end
  end

  down do
    drop_table(:orders)
  end
end
