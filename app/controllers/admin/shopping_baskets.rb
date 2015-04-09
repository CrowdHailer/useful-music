module UsefulMusic
  module Admin
    class ShoppingBasketsController < UsefulMusic::App
      include Scorched::Rest

      render_defaults[:dir] += '/admin/shopping_baskets'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @shopping_baskets = ShoppingBaskets.new request.GET
        render :index
      end
    end
  end
end
