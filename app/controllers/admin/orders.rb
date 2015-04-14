module UsefulMusic
  module Admin
    class OrdersController < UsefulMusic::App
      patch('/remind') { |id| send :remind_all }
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
        order.reminder_sent
        flash['success'] = "Order reminder delivered to #{order.customer.email}"
        redirect '/admin/orders'
      end

      def remind_all
        # yesterday = DateTime.now - 1
        Orders
          .new
          .dataset
          .where(:reminded_at => nil)
          .where{completed_at < (DateTime.now - 3)}
          .each do |record|
            order = Order.new record
            mailer = CustomerMailer.new order.customer , :application_url => url
            mailer.order_reminder(order)
            order.reminder_sent
          end
        flash['success'] = 'reminders sent'
        redirect '/admin/orders'
      end
    end
  end
end
