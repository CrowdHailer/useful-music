class UsersController < UsefulMusic::App
  include Scorched::Rest

  def index
    'All users'
  end

  def new
    'New users'
  end

  def create
    'creating user'
  end

end
