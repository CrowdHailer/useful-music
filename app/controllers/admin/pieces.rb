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
          piece = Piece.create form
          flash['success'] = 'Piece created'
          redirect "/admin/pieces"
        rescue Sequel::UniqueConstraintViolation => err
          flash['error'] = "Piece UD#{form.id} already exists and may be edited"
          redirect "/pieces/UD#{form.id}/edit"
        rescue Sequel::NotNullConstraintViolation => err
          Bugsnag.notify(err)
          flash['error'] = 'Could not create invalid piece'
          redirect '/pieces/new'
        end
      end
    end
  end
end
