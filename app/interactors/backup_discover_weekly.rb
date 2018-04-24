class BackupDiscoverWeekly
  include Interactor::Organizer
  include SpotifyUserContext
  
  organize FindDiscoverWeekly, GetPlaylistFromSpotify, CreatePlaylistOnSpotify, CreatePlaylistRecord, CreateTrackRecords

  # call accepts one argument of a User object
  def call
    setup_context
    super
  end

  private
  def setup_context
    context.tap do |c|
      c.backup_playlist_name = Playlist.this_week_backup_name
      c.discover_weekly_id = context.user.discover_weekly_id
    end
  end
end
