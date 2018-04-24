class CreatePlaylistRecord
  include Interactor

  # needed context #
  # user object
  # playlist_name
  # backup_spotify_playlist

  def call
    db_playlist = context.user.playlists.create(name: context.playlist_name)
    db_playlist.update_with_spotify(context.backup_spotify_playlist) if context.user.auto_sync?

    unless db_playlist.persisted?
      context.fail! message: db_playlist.errors.full_messages.to_sentence
    end

    context.db_playlist = db_playlist
  end
end
