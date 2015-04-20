class Usecase
  def self.outcomes(*outcomes)
    define_method possible_outcomes do
      outcomes
    end
  end

  def valid_outcome?(attempted)
    outcomes.include attempted
  end


  def run!
    raise 'Should put sometihng here'
  end

  def run
    @outcome, *@returns = Array.new run!
  end

  def method_missing(method_sym, *arguments, &block)
    if valid_outcome? method_sym
      block.call(*returns)
    else
      super
    end
  end
end

class OCreate
  outcomes :created, :invalid_details, :email_taken

  def initialize(context, params)
    @context = context
    @params = params
  end

  def run
    report :invalid_details, form unless form.valid?
    begin
      customer = Customers.create form
    rescue Sequel::UniqueConstraintViolation => err
      report :email_taken, form
    end
    notify_user :account_created, customer
    notify_admin :account_created, customer
    report :created, customer
  end

  def current_user
    @context.current_user
  end

  def form
    @form ||= Form.new @params
  end

end

class Customerz

end
class Customerz::Create
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

class Customerz::Update
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
