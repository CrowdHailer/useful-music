Sequel.migration do
  up do
    extension(:constraint_validations)
    create_table(:orders) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :state, :null => false
      Integer :basket_amount, :null => false
      Integer :tax_amount, :null => false
      Integer :discount_amount, :null => false
      String :payer_email
      String :payer_first_name
      String :payer_last_name
      String :payer_company
      String :payer_status
      String :payer_identifier
      String :token
      String :transaction_id

      DateTime :created_at
      DateTime :updated_at
      foreign_key :shopping_basket_id, :shopping_baskets, :type => :varchar, :unique => true, :null => false
      foreign_key :customer_id, :customers, :type => :varchar, :null => false
      validate do
        includes 0...100000, :basket_amount, :name => 'basket_limit'
        includes 0...100000, :tax_amount, :name => 'tax_limit'
        includes 0...100000, :discount_amount, :name => 'discount_limit'
        includes ['pending', 'processing', 'succeded', 'failed'], :state
      end
    end
  end

  down do
    extension(:constraint_validations)
    drop_table(:orders)
  end
end
