class DiscountsController < UsefulMusic::App
  include Scorched::Rest

  render_defaults[:dir] += '/discounts'

  def index
    check_access
    render :index
  end

  def check_access
    if current_customer.admin?
      true
    else
      flash['error'] = 'Access denied'
      redirect '/'
    end
  end
end
