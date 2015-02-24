module Customers
  class Query
    def initialize(options={})
      @options = options
    end

    attr_reader :options

    def page
      a = options.fetch('page', 1).to_i
      a == 0 ? 1 : a
    end

    def page_size
      a = options.fetch('page_size', 20).to_i
      a == 0 ? 20 : a
    end

    def order
      :email
      options.fetch('order', :email).to_sym
    end
  end

  class WrapCollection < SimpleDelegator
    # TODO i think map will delegate not use new each
    def initialize(collection, &wrapper)
      super
      @wrapper = wrapper
    end

    def each
      collection.each do |item|
        yield @wrapper.call(item)
      end
    end

    def collection
      __getobj__
    end
  end

  class Page
    def initialize(record_set, options={})
      @record_set = record_set
      @options = Query.new(options)
    end

    attr_reader :record_set, :options

    def records_page
      WrapCollection.new(record_set.paginate(options.page, options.page_size)) do |record|
        Customer.new(record)
      end
    end

    delegate :page_size,
             :page_count,
             :current_page,
             :first_page?,
             :last_page?,
             :next_page,
             :prev_page,
             :page_range,
             :each,
             :to => :records_page
  end
  # extend self
  # TODO untested
  class << self

    def empty?
      Customer::Record.empty?
    end

    def all(query_params={})
      Page.new(Customer::Record.dataset, query_params)
      # WrapPage.new(Customer::Record.dataset.paginate(2,13)) {|r| Customer.new r}
    end

    def last
      record = Customer::Record.last
      Customer.new(record) if record
    end

    def find(id)
      record = Customer::Record[id]
      Customer.new(record) if record
    end

    def authenticate(email, password)
      record = Customer::Record.find(:email => email)
      customer = record.nil? ? nil : Customer.new(record)
      return false unless customer && customer.authenticate(password)
      customer
    end
  end
end
