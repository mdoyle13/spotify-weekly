class SpotifyWeeklyPlaylistService < BaseSpotifyService
  def call
    super
    
    unless spotify_user
      return fail! msg: "Sorry, there was a problem authenticating with Spotify"
    end

    playlist = get_weekly_playlist
    
    if playlist
      @response.send("success?=", true)
      # attach the playlist object the playlist attribute of the @response
      @response.playlist = playlist
    else
      @response.message = "You are not following Discover Weekly. Once you do that come back and try again"
    end
    @response
  end

  private
  
  def get_weekly_playlist
    playlist = get_all_playlists.select {|p| p.name == "Discover Weekly"}[0]
  end
  
  #TODO FIX ME: this could get crazy if a user has a ton of playlists. 
  def get_all_playlists
    playlists = []
    offset = 0
    loop do
      _playlists = spotify_user.playlists(limit: 50, offset: offset)
      break if _playlists.count == 0
      playlists << _playlists
      offset += 50
    end
    playlists.flatten
  end
end