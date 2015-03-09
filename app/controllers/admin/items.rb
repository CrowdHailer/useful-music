# Add to the following if errors occur in admin usage
# Does not check redirection when item missing - create repository use fetch
# Does not return details of failed params - create form validator
module UsefulMusic
  module Admin
    class ItemsController < UsefulMusic::App
      include Scorched::Rest

      render_defaults[:dir] += '/admin/items'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def new
        @piece = Catalogue.fetch(request.GET.fetch('piece_id') { '' })
        render :new
      end

      def create
        begin
          form = Item::Create::Form.new request.POST['item']
          item = Items.create form
          flash['success'] = 'Item created'
          redirect "/admin/pieces/#{item.piece.catalogue_number}/edit"
        rescue Sequel::ConstraintViolation => err
          Bugsnag.notify(err)
          flash['error'] = 'Could not create invalid item'
          redirect(request.referer || '/pieces')
        end
      end

      def edit(id)
        @item = Items.fetch(id, &method(:item_not_found))
        render :edit
      end

      def update(id)
        begin
          item = Items.fetch(id, &method(:item_not_found))
          form = Item::Create::Form.new request.POST['item']
          hash =  form.to_hash
          hash.delete(:piece)
          item.set! hash
          redirect "/admin/pieces/#{item.piece.catalogue_number}/edit"
        rescue Sequel::ConstraintViolation => err
          Bugsnag.notify(err)
          flash['error'] = 'Could not update - invalid parameters'
          redirect(request.referer || '/admin/pieces')
        end
      end

      def destroy(id)
        item = Items.fetch(id, &method(:item_not_found))
        item.destroy
        redirect "/pieces/#{item.piece.catalogue_number}/edit"
      end

      def item_not_found(id)
        flash['error'] = 'Item not found'
        redirect '/pieces'
      end

    end
  end
end
