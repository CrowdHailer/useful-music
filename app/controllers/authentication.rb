class AuthenticationController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/authentication'

  get '/unauthenticated' do
    env['warden.options']
    render :login
  end

  post '/' do
    warden_handler.authenticate!
  end

  def xsc
    5
  end

  get '/private' do
    warden_handler.authenticate!
    ap 'private'
  end

  # def
end
