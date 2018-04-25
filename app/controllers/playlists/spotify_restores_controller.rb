class Playlists::SpotifyRestoresController < ApplicationController
  def create
    @playlist = Playlist.find(params[:playlist_id])
    spotify_restore = RestorePlaylistToSpotify.call(user: current_user, db_playlist: @playlist)

    if spotify_restore.success?
      flash[:notice] = "Successfully restored playlist to Spotify"
    else
      flash[:error] = spotify_restore.message
    end

    redirect_to dashboard_path
  end
end
