class SessionsController < Devise::SessionsController
  def new
    redirect_to root_path
  end

  def create
    super
  end
end