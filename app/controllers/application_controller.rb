class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
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
end
