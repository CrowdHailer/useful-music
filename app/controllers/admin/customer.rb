module UsefulMusic
  module Admin
    class CustomersController < App
      render_defaults[:dir] += '/admin/customers'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym
      
      get '/' do
        render :index
      end
    end
  end
end
