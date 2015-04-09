module UsefulMusic
  module Admin
    class DiscountsController < UsefulMusic::App
      include Scorched::Rest

      render_defaults[:dir] += '/admin/discounts'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @discounts = Discounts.new
        render :index
      end

      def new
        render :new
      end

      def create
        form = Discount::Create::Form.new request.POST['discount']
        Discount::Record.create form.to_hash
        flash['success'] = 'Discount Created'
        redirect '/admin/discounts'
      end

      def edit(id)
        @discount = Discounts[id]
        render :edit
      end

      def update(id)
        form = Discount::Create::Form.new request.POST['discount']
        discount = Discounts[id]
        discount.set form.to_hash
        Discounts.save discount
        flash['success'] = 'Discount Updated'
        redirect '/admin/discounts'
      end

      def destroy(id)
        discount = Discounts[id]
        begin
          Discounts.remove(discount)
          flash['success'] = 'Discount Deleted'
          redirect '/admin/discounts'
        rescue Sequel::ForeignKeyConstraintViolation => err
          flash['error'] = 'Discount could not be delete, it has been used'
          redirect '/admin/discounts'
        end
      end

    end
  end
end
