class BaseSpotifyService
    def initialize(user)
    @user_record = user
    @response = OpenStruct.new(success?: false, message: nil)

    # try to oauth with spotify
    begin
      @spotify_user = RSpotify::User.new(user.auth_hash)
    rescue
      @response.message = "there was a problem authenticating with spotify please try again later"
      return @response
    end
  end
end