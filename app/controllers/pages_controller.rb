class PagesController < ApplicationController
  def home
    if user_signed_in?
      return redirect_to dashboard_path
    end

    render layout: 'home'
  end
end
