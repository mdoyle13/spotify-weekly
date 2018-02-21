class SpotifyBackupService < BaseSpotifyService
    attr_accessor :spotify_playlist, :name

    def call
      super
      sync_discover_weekly
    end
    
    private
    def sync_discover_weekly
      # get the users weekly playlist from spotify
      @spotify_playlist = get_discover_weekly
      
      # if its not there for some reason we cannot proceed
      unless spotify_playlist
        return fail! msg: "You need to follow the discover weekly playlist :("
      end

      db_playlist = user_record.playlists.new

      # check this so we dont proceed if they playlist is invalid
      unless db_playlist.valid?
         return fail! msg: db_playlist.errors.full_messages.to_sentence
      end

      # create the playlist on spotify and pass it the name
      @name = db_playlist.week_of_name
      remote_playlist = create_playlist_on_spotify( name )

      unless remote_playlist
        return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
      end

      # playlist has saved to user's spotify account, now store it in the database
      db_playlist.tap do |pl|
          pl.name = name
          pl.spotify_id = remote_playlist.id
          pl.data = remote_playlist
      end

      unless db_playlist.save
        return fail! msg: db_playlist.errors.full_messages.to_sentence
      end

      # reverse the tracks so they are created in the same order as on spotify?
      remote_playlist.tracks.each do |track|
         db_playlist.tracks.create(spotify_id: track.id, data: track)
      end

      response.send("success?=", true)
      response.message = "Huzzah - We have your Discover Weekly playlist. It will now be backed up every week, automatically"
      return response
  end

  def get_discover_weekly
    # fetch discover weekly from spotify
    spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
  end

  def create_playlist_on_spotify(name)
    playlist = spotify_user.create_playlist!(name)
    playlist.add_tracks!(spotify_playlist.tracks)
    playlist
  end
end