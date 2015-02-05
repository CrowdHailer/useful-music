class ArrangementsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/arrangements'

  def new
    render :new
  end

  def create
    request.POST['arrangement'].to_s
  end
end
