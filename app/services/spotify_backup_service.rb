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
        puts "no spotify playlist"
        return fail! msg: "You need to follow the discover weekly playlist :("
      end

      # check this so we dont proceed if they playlist is invalid
      if user_record.has_this_week_backup?
        puts "no backup"
        return fail! msg: "It appears you already have a backup for this week"
      end

      # create the playlist on spotify and pass it the name
      @name = Playlist.this_week_backup_name
      remote_playlist = create_playlist_on_spotify( name )

      unless remote_playlist
        return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
      end

      # playlist has saved to user's spotify account, now store it in the database
      db_playlist = user_record.playlists.new.update_with_spotify(remote_playlist)

      unless db_playlist.persisted?
        return fail! msg: db_playlist.errors.full_messages.to_sentence
      end

      # reverse the tracks so they are created in the same order as on spotify?
      remote_playlist.tracks.each do |track|
         db_playlist.tracks.create(spotify_id: track.id, data: track)
      end

      response.send("success?=", true)
      response.message = "Huzzah - Your Discover Weekly playlist for this week is backed up. It will now be backed up every week, automatically"
      return response
    end

    def get_discover_weekly
      puts "get dw"
      # fetch discover weekly from spotify, spotify is the owner of the playlist
      RSpotify::Playlist.find("spotify", user_record.discover_weekly_id)
    end

    def create_playlist_on_spotify
      playlist = spotify_user.create_playlist!(playlist_name)
      playlist.add_tracks!(spotify_playlist.tracks)

      unless playlist
        return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
      end

      playlist
    end
end
