class SpotifyBackupService < BaseSpotifyService
    def call
      sync_discover_weekly
    end
    
    private
    def sync_discover_weekly
      # get the users weekly playlist from spotify
      @spotify_playlist = get_discover_weekly
      
      # if its not there for some reason we cannot proceed
      unless @spotify_playlist
        @response.message = "You need to follow the discover weekly playlist :("
        return @response
      end

      db_playlist = @user_record.playlists.new

      # check this so we dont proceed if they playlist is invalid
      unless db_playlist.valid?
         @response.message = db_playlist.errors.full_messages.to_sentence
         return @response
      end

      # create the playlist on spotify and pass it the name
      name = db_playlist.week_of_name
      remote_playlist = create_playlist_on_spotify(name)

      unless remote_playlist
        @response.message = "Couldn't create the playlist on Spotify. Please try again later"
        return @response
      end

      # playlist has saved to user's spotify account, now store it in the database
      db_playlist.tap do |pl|
          pl.name = name
          pl.spotify_id = remote_playlist.id
          pl.data = remote_playlist
      end

      unless db_playlist.save
        @response.message = db_playlist.errors.full_messages.to_sentence
        return @response
      end

      # reverse the tracks so they are created in the same order as on spotify?
      remote_playlist.tracks.each do |track|
         db_playlist.tracks.create(spotify_id: track.id, data: track)
      end

      @response.send("success?=", true)
      @response.message = "Huzzah - your Discover Weekly playlist is backed up"
      return @response
  end

  def get_discover_weekly
    # fetch discover weekly from spotify
    @spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
  end

  def create_playlist_on_spotify(name)
    playlist = @spotify_user.create_playlist!(name)
    playlist.add_tracks!(@spotify_playlist.tracks)
    playlist
  end
end