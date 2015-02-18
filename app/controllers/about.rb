class AboutController < UsefulMusic::App
  render_defaults[:dir] += '/about'

  get '/' do
    render :index
  end

  get '/composers' do
    render :composers
  end

  get '/search_and_purchase' do
    render :search_and_purchase
  end

  get '/licencing_and_copyright' do
    render :licencing_and_copyright
  end

  get '/refunds' do
    render :refunds
  end

  get '/privacy' do
    render :privacy
  end

  get '/terms_and_conditions' do
    render :terms_and_conditions
  end

  get '/contact' do
    render :contact
  end

  get '/sitemap' do
    render :sitemap
  end
end
