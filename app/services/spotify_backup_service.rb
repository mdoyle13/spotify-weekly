class SpotifyBackupService < BaseSpotifyService
  attr_accessor :spotify_playlist, :playlist_name

  def call
    super
    sync_discover_weekly
  end

  private
    def sync_discover_weekly
      # get the users weekly playlist from spotify
      @spotify_playlist = get_discover_weekly
      @playlist_name = Playlist.this_week_backup_name

      # if its not there for some reason we cannot proceed
      unless spotify_playlist
        puts "no spotify playlist"
        return fail! msg: "You need to follow the discover weekly playlist :("
      end

      # check this so we dont proceed if they playlist is invalid
      if user_record.has_this_week_backup?
        puts "no backup"
        return fail! msg: "It appears you already have a backup for this week"
      end

      # if the user has auto_sync on
      if user_record.auto_sync?
        # create the playlist on spotify
        remote_playlist = create_playlist_on_spotify
      end

      # now store the playlist in the database
      db_playlist = user_record.playlists.create!(name: playlist_name)
      db_playlist.update_with_spotify(remote_playlist) if user_record.auto_sync?

      unless db_playlist.persisted?
        return fail! msg: db_playlist.errors.full_messages.to_sentence
      end

      # reverse the tracks so they are created in the same order as on spotify?
      spotify_playlist.tracks.each do |track|
         db_playlist.tracks.create(spotify_id: track.id, data: track)
      end

      response.send("success?=", true)
      response.message = "Huzzah - Your Discover Weekly playlist for this week is backed up."
      return response
    end

    def get_discover_weekly
      puts "get dw"
      # fetch discover weekly from spotify, spotify is the owner of the playlist
      RSpotify::Playlist.find("spotify", user_record.discover_weekly_id)
    end

<<<<<<< HEAD
  def create_playlist_on_spotify
    playlist = spotify_user.create_playlist!(playlist_name)
    playlist.add_tracks!(spotify_playlist.tracks)

    unless playlist
      return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
    end

    playlist
  end
=======
    def create_playlist_on_spotify
      playlist = spotify_user.create_playlist!(playlist_name)
      playlist.add_tracks!(spotify_playlist.tracks)

      unless playlist
        return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
      end

      playlist
    end
>>>>>>> master
end
