class SpotifyWeeklyPlaylistService < BaseSpotifyService
  def call
    super
    
    unless spotify_user
      return fail! msg: "Sorry, there was a problem authenticating with Spotify"
    end

    playlist = get_weekly_playlist
    
    if playlist
      @response.send("success?=", true)
      @response.playlist = playlist
    else
      @response.message = "You are not following Discover Wekly. Once you do that come back and try again"
    end
    @response
  end

  private
  def get_weekly_playlist
    playlist = spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
  end
end