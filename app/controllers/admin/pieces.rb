module UsefulMusic
  module Admin
    class PiecesController < UsefulMusic::App
      include Scorched::Rest

      render_defaults[:dir] += '/admin/pieces'
      render_defaults[:layout] = File.expand_path('app/views/admin/application', APP_ROOT).to_sym

      def index
        @pieces = Catalogue.new request.GET
        render :index
      end

      def new
        render :new
      end

      def create
        begin
          form = Piece::Create::Form.new request.POST['piece']
          piece = Catalogue.create form
          flash['success'] = 'Piece created'
          redirect "/admin/pieces"
        rescue Sequel::UniqueConstraintViolation => err
          flash['error'] = "Piece UD#{form.id} already exists and may be edited"
          redirect "/admin/pieces/UD#{form.id}/edit"
        rescue Sequel::NotNullConstraintViolation => err
          # Bugsnag.notify(err)
          flash['error'] = 'Could not create invalid piece'
          redirect '/admin/pieces/new'
        end
      end

      def edit(catalogue_number)
        @piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
        render :edit
      end

      def update(catalogue_number)
        piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
        form = Piece::Update::Form.new request.POST['piece']
        piece.set! form
        flash['success'] = 'Piece updated'
        redirect "/admin/pieces"
      end

      def destroy(catalogue_number)
        piece = Catalogue.fetch(catalogue_number, &method(:piece_not_found))
        piece.destroy
        flash['success'] = 'Piece deleted'
        redirect "/admin/pieces"
      end

      def piece_not_found(id)
        flash['error'] = 'Piece not found'
        redirect "/admin/pieces"
      end
    end
  end
end
