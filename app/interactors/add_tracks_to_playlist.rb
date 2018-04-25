class AddTracksToPlaylist
  include Interactor
  def call
    context.spotify_playlist.add_tracks!(spotify_tracks)
  end

  private
  def spotify_tracks
     RSpotify::Track.find(track_ids)
  end

  def track_ids
    context.db_playlist.tracks.order('id ASC').collect(&:spotify_id)
  end
end
