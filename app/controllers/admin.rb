Dir[File.expand_path('../admin/*.rb', __FILE__)].each do |file|
  require file
end

module UsefulMusic
  class AdminController < App
    before do
      admin_logged_in? or deny_access
    end

    controller '/customers', Admin::CustomersController
    controller '/discounts', Admin::DiscountsController
    controller '/pieces', Admin::PiecesController
    controller '/items', Admin::ItemsController

    get '/' do
      'c'
    end
  end
end
