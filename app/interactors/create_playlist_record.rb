class CreatePlaylistRecord
  include Interactor

  # needed context
  # user object
  # playlist_name
  # backup_spotify_playlist is optional

  def call
    db_playlist = context.user.playlists.create(name: context.playlist_name)
    # if the user has auto_sync on then update the playlist record with the spotify playlist info
    # the backup_spotify_playlist context will not be present if user.auto_sync is false
    db_playlist.update_with_spotify(context.backup_spotify_playlist) if context.user.auto_sync?

    unless db_playlist.persisted?
      # unfollow the playlist from spotify if this step doesn't work correctly
      context.spotify_user.unfollow(context.backup_spotify_playlist) if context.user.auto_sync?
      
      context.fail! message: db_playlist.errors.full_messages.to_sentence
    end

    context.db_playlist = db_playlist
  end
end
