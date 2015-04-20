class Customer::Create
  def initialize(context, params)
    @context = context
    @params = params
  end

  def run
    return :invalid_details, form unless form.valid?
    begin
      customer = Customers.create form
    rescue Sequel::UniqueConstraintViolation => err
      return :email_taken, form
    end
    notify_user :account_created, customer
    notify_admin :account_created, customer
    return :created, customer
  end

  def result # New name
    @result ||= Array.new run
  end

  def outcome
    result.first
  end

  def returns
    result[1..-1]
  end

  def created
    yield *returns if created?
  end

  def created?
    outcome == :created
  end

  def current_user
    @context.current_user
  end

  def form
    @form ||= Customer::Create::Form.new @params
  end
end

class Customer::Update
  def initialize(context, id, params)
    @context = context
    @id = id
    @params = params
  end

  def run
    return :invalid_details, form unless form.valid?
    begin
      customer = Customers.create form
    rescue Sequel::UniqueConstraintViolation => err
      return :email_taken, form
    end
    notify_user :account_created, customer
    notify_admin :account_created, customer
    return :created, customer
  end

  def result # New name
    @result ||= Array.new run
  end

  def outcome
    result.first
  end

  def returns
    result[1..-1]
  end

  def created
    yield *returns if created?
  end

  def created?
    outcome == :created
  end

  def customer_account
    Customers.fetch
  end

  def current_user
    @context.current_user
  end

  def form
    @form ||= Form.new @params
  end
end
