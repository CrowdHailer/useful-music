Dir[File.expand_path('../admin/*.rb', __FILE__)].each do |file|
  require file
end

module UsefulMusic
  class AdminController < App
    before do
      admin_logged_in? or deny_access
    end

    controller '/customers', Admin::CustomersController

    get '/' do
      'c'
    end
  end
end
