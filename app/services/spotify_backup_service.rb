require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

class SpotifyBackupService < BaseSpotifyService  
  def call
    super
    sync_discover_weekly
  end

  private
    def sync_discover_weekly
      # get the users weekly playlist from spotify
      @spotify_playlist = get_discover_weekly
      @playlist_name = Playlist.this_week_backup_name

      # if its not there for some reason we cannot proceed so fail
      unless @spotify_playlist
        return fail! msg: "You need to follow the discover weekly playlist :("
      end

      # if the user has auto_sync on
      if user_record.auto_sync?
        # create the playlist on spotify
        remote_playlist = create_playlist_on_spotify
      end

      # now store the playlist in the database
      @db_playlist = user_record.playlists.create(name: @playlist_name)
      @db_playlist.update_with_spotify(remote_playlist) if user_record.auto_sync?

      unless @db_playlist.persisted?
        return fail! msg: @db_playlist.errors.full_messages.to_sentence
      end

      Track.import build_tracks, validate: true

      response.send("success?=", true)
      response.message = "Huzzah - Your Discover Weekly playlist for this week is backed up."
      return response
    end
    
    def get_discover_weekly
      # fetch discover weekly from spotify, "spotify" is the owner of the playlist, not the user
      RSpotify::Playlist.find("spotify", user_record.discover_weekly_id)
    end

    def create_playlist_on_spotify
      playlist = spotify_user.create_playlist!(@playlist_name)
      playlist.add_tracks!(@spotify_playlist.tracks)

      unless playlist
        return fail! msg: "Couldn't create the playlist on Spotify. Please try again later"
      end

      playlist
    end
    
    def build_tracks
      tracks_array = []
      @spotify_playlist.tracks.each do |track|
        tracks_array << @db_playlist.tracks.build(spotify_id: track.id, data: track)
      end
      tracks_array
    end
    
end
