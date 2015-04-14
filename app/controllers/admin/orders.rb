module UsefulMusic
  module Admin
    class OrdersController < UsefulMusic::App
      patch('/:id/remind') { |id| send :remind, id }
      include Scorched::Rest

      render_defaults[:dir] += '/admin/orders'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @orders = Orders.new request.GET
        render :index
      end

      def remind(id)
        order = Orders.fetch(id)
        mailer = CustomerMailer.new order.customer , :application_url => url
        mailer.order_reminder(order)
        flash['success'] = "Order reminder delivered to #{order.customer.email}"
        redirect '/admin/orders'
      end
    end
  end
end
