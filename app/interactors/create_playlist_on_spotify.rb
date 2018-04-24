class CreatePlaylistOnSpotify
  include Interactor

  # context needed #
  # spotify_user object
  # backup_playlist_name string
  # discover_weekly_playlist object
  def call
    return unless context.user.auto_sync?
    begin
     playlist = context.spotify_user.create_playlist!(context.backup_playlist_name)
     playlist.add_tracks!(context.discover_weekly_playlist.tracks)
     context.backup_spotify_playlist = playlist
   rescue
     context.fail!(message: "Couldn't create the playlist on Spotify. Please try again later")
   end
  end
end
