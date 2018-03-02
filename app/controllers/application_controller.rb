class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :redirect_heroku_url

  def not_found
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.any { head :not_found }
    end
  end

  def error
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/500", :layout => false, :status => :error }
      format.any { head :not_found }
    end
  end

  protected
  
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def redirect_heroku_url
    if request.host == "spotify-weekly.herokuapp.com"
      redirect_to "#{request.protocol}rediscoverweekly.com#{request.fullpath}", status: :moved_permanently
    end
  end
end
