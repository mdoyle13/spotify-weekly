class PagesController < ApplicationController
  before_action :authenticate_user!, only: :help
  def home
    if user_signed_in?
      return redirect_to dashboard_path
    end

    render layout: 'home'
  end

  def help
  end
end
