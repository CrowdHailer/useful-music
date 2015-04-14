module UsefulMusic
  module Admin
    class ShoppingBasketsController < UsefulMusic::App
      class ClearInactiveForm
        include Virtus.model

        attribute :since, Date

        def since
          super.is_a?(Date) ? super : Date.yesterday
        end
      end
      include Scorched::Rest

      render_defaults[:dir] += '/admin/shopping_baskets'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @shopping_baskets = ShoppingBaskets.new request.GET
        render :index
      end

      def destroy(id)
        shopping_basket = ShoppingBaskets[id]
        begin
          ShoppingBaskets.remove(shopping_basket)
          flash['success'] = 'Discount Deleted'
          redirect '/admin/shopping_baskets'
        rescue Sequel::ForeignKeyConstraintViolation => err
          flash['error'] = 'Shopping Basket could not be cleared it is still referenced'
          redirect '/admin/shopping_baskets'
        end
      end

      delete '/' do
        form = ClearInactiveForm.new request.POST
        ShoppingBaskets.clear_inactive(:since => form.since)
        redirect '/admin/shopping_baskets'
      end
    end
  end
end
