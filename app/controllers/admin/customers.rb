module UsefulMusic
  module Admin
    class CustomersController < App
      include Scorched::Rest
      render_defaults[:dir] += '/admin/customers'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @customers = Customers.all request.GET
        render :index
      end
    end
  end
end
