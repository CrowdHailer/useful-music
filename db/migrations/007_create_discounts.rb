Sequel.migration do
  up do
    create_table(:discounts) do
      primary_key :id, :type => :varchar, :auto_increment => false, :unique => true
      String :code, :null => false
      constraint(:min_code_length, Sequel.function(:char_length, :code)=>3..50)
      Integer :value, :null => false
      constraint(:value_range, :value => 1...100000)
      Integer :allocation, :null => false
      constraint(:allocation_range, :allocation => 1...1000000)
      Integer :customer_allocation, :null => false
      constraint(:customer_allocation_range, :customer_allocation => 1...10)
      DateTime :start_datetime, :null => false
      DateTime :end_datetime, :null => false

      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table(:discounts)
  end
end
