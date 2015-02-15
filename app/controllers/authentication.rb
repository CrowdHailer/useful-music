class AuthenticationController < UsefulMusic::App
  # NOTE: need to create new string to assign in config dir
  render_defaults[:dir] += '/authentication'

  get '/login' do
    render :login
  end

  post '/unauthenticated' do
    # ap env['warden.options']
    redirect "/authentication/login?attempted_path=#{env['warden.options'][:attempted_path]}"
  end

  post '/login' do
    warden_handler.authenticate!
    redirect request.GET.fetch('attempted_path')
  end

  get '/private' do
    warden_handler.authenticate!
    'hello'
  end

end
