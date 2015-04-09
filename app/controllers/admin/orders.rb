module UsefulMusic
  module Admin
    class OrdersController < UsefulMusic::App
      include Scorched::Rest

      render_defaults[:dir] += '/admin/orders'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @orders = Orders.new request.GET
        render :index
      end
    end
  end
end
