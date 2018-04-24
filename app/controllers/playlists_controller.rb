class PlaylistsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_playlist, only: [:show, :destroy, :restore_to_spotify]

  def show
    @tracks = @playlist.tracks.order('id ASC')
  end

  def destroy
    if @playlist.destroy
      flash[:notice] = "Successfully deleted playlist"
    else
      flash[:error] = "There was a problem deleting the playlist"
    end

    redirect_to dashboard_path
  end

  def restore_to_spotify
    spotify_restore = RestorePlaylistToSpotify.call(user: current_user, playlist: @playlist)

    if spotify_restore.success?
      flash[:notice] = "Successfully restored playlist to Spotify"
    else
      flash[:error] = spotify_restore.message
    end
    
    redirect_to dashboard_path
  end

  def initial_discover_weekly_sync
    spotify_backup = BackupDiscoverWeekly.call(user: current_user)

    if spotify_backup.success?
      flash[:notice] = "Huzzah - Your Discover Weekly playlist for this week is backed up."
    else
      flash[:error] = spotify_backup.message
      return redirect_to dashboard_path
    end

    return redirect_to dashboard_path
  end


  def sync_discover_weekly
    spotify_backup = BackupDiscoverWeekly.call(user: current_user)

    if spotify_backup.success?
      flash[:notice] = "Huzzah - Your Discover Weekly playlist for this week is backed up."
    else
      flash[:error] = spotify_backup.message
    end

    redirect_to dashboard_path
  end

  private
  def load_playlist
    @playlist = current_user.playlists.where(id: params[:id]).first
    return not_found unless @playlist
  end
end
