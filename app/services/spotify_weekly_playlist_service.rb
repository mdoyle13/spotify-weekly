class SpotifyWeeklyPlaylistService
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

  def call
    playlist = get_weekly_playlist
    if playlist
      @response.send("success?=", true)
      @response.playlist = playlist
    else
      @response.message = "You're not following discover weekly"
    end
    @response
  end

  private
  def get_weekly_playlist
    playlist = @spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
  end
end