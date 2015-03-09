module UsefulMusic
  module Admin
    class CustomersController < App
      include Scorched::Rest
      post('/:id/admin') { |id| send :make_admin, id }
      delete('/:id/admin') { |id| send :remove_admin, id }

      render_defaults[:dir] += '/admin/customers'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @customers = Customers.new request.GET
        render :index
      end

      def make_admin(id)
        customer = Customers.fetch(id, &method(:customer_not_found))
        customer.set :admin => true
        Customers.save customer
        flash['success'] = "#{customer.name} is now an admin"
        redirect '/admin/customers'
      end

      def remove_admin(id)
        customer = Customers.fetch(id, &method(:customer_not_found))
        customer.set :admin => false
        Customers.save customer
        flash['success'] = "#{customer.name} is now not an admin"
        redirect '/admin/customers'
      end

      def customer_not_found(id)
        flash['error'] = 'Customer not found'
        redirect '/admin/customers'
      end

    end
  end
end
