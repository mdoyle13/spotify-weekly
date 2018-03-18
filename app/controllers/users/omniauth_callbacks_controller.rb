class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def spotify

    # handle the database part of the auth
    @user = User.from_omniauth(request.env["omniauth.auth"])
    
    # stay logged in please
    @user.remember_me = true

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Spotify") if is_navigational_format?

    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end
end
