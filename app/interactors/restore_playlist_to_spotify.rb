class RestorePlaylistToSpotify
  include Interactor
  include SpotifyUserContext

  # context needed
  # user object
  # playlist object
  def call
    create_playlist_on_spotify
    add_tracks_to_playlist
    #update with the spotify specific data
    if context.playlist
      context.playlist.update_with_spotify(context.spotify_playlist)
    else
      context.fail!(message: "Sorry, there was a problem creating the playlist on Spotify")
    end
  end

  private
  def create_playlist_on_spotify
    context.spotify_playlist = context.spotify_user.create_playlist!(Playlist.this_week_backup_name)
  end

  def add_tracks_to_playlist
    context.spotify_playlist.add_tracks!(spotify_tracks)
  end

  def spotify_tracks
     RSpotify::Track.find(track_ids)
  end

  def track_ids
    context.playlist.tracks.order('id ASC').collect(&:spotify_id)
  end
end
