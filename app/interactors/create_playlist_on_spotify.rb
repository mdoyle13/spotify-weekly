class CreatePlaylistOnSpotify
  include Interactor

  def call
    begin
      context.spotify_playlist = context.spotify_user.create_playlist!(Playlist.this_week_backup_name)
      context.db_playlist.update_with_spotify(context.spotify_playlist)
    rescue
      context.fail!(message: "Sorry, there was a problem creating the playlist on Spotify")
    end
  end
end
