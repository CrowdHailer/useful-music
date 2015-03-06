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
    end
  end
end
