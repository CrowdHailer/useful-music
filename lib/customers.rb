module Customers
  extend self
  # TODO untested

  def all
    Customer::Record.all.map{ |r| Customer.new r }
  end
end
