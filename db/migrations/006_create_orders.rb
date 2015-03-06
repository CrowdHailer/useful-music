Sequel.migration do
  up do
    create_table(:orders) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :state, :null => false
      constraint(:allowed_states, :state => ['pending', 'processing', 'succeded', 'failed'])
      Integer :basket_amount, :null => false
      constraint(:basket_amount_limit, :basket_amount => 0...100000)
      Integer :tax_amount, :null => false
      constraint(:tax_amount_limit, :tax_amount => 0...100000)
      Integer :discount_amount, :null => false
      constraint(:discount_amount_limit, :discount_amount => 0...100000)
      String :license
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
    end
  end

  down do
    drop_table(:orders)
  end
end
