class ArrangementsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/arrangements'

  def new
    # ap render_defaults
    render :new
  end
end
