class SpotifyWeeklyPlaylistService < BaseSpotifyService
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