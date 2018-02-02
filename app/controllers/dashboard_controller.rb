class DashboardController < ActionController::Base
  before_action :authenticate_user!
  
  layout "application"

  def index
    @playlists = current_user.playlists.order('id ASC')
  end
end
