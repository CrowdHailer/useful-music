require_relative '../../test_config'

class Order
  class Create
    class FormTest < MyRecordTest
      # def test_obtains_customer
      #   customer = Customer.new create(:customer_record)
      #   form = Form.new :customer => customer.id
      #   assert_equal customer, form.customer
      # end
      #
      # def test_is_invalid_with_unknown_customer
      #   form = Form.new :customer => '21'
      #   refute form.valid?
      # end
    end
  end
end
