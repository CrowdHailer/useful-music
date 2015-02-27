require_relative '../test_config'

class CustomersTest < MyRecordTest
  def test_case_name
    12.times {FactoryGirl.create :customer_record}
    # ap Customers.all.count
    
  end
end
