class SessionsController < UsefulMusic::App
  include Scorched::Rest

  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/sessions'

  def new
    render :new
  end
end
