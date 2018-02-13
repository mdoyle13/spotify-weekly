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
    spotify_service = BaseSpotifyService.new(current_user)
    
    spotify_user = spotify_service.spotify_user

    db_tracks = @playlist.tracks.order('id ASC').collect(&:spotify_id)
    spotify_tracks = RSpotify::Track.find(db_tracks)
    
    playlist = spotify_user.create_playlist!(@playlist.name)
    
    playlist.add_tracks!(spotify_tracks)

    redirect_to dashboard_path
  end

  def retrieve_discover_weekly
    # this method will be called when a user needs to manually attach the weekly id

    @spotify_weekly_playlist_service = SpotifyWeeklyPlaylistService.new(current_user).call
    
    if @spotify_weekly_playlist_service.success?
      current_user.discover_weekly_id = @spotify_weekly_playlist_service.playlist.id
      current_user.save

      # TODO: Don't do this like this. its gross.
      return sync_discover_weekly
    else
      flash[:error] = @spotify_weekly_playlist_service.message
    end

    redirect_to dashboard_path
  end

  def sync_discover_weekly
    @spotify_service = SpotifyBackupService.new(current_user).call

    if @spotify_service.success?
      flash[:notice] = @spotify_service.message
    else
      flash[:error] = @spotify_service.message
    end
    
    redirect_to dashboard_path
  end

  private
  def load_playlist
    @playlist = current_user.playlists.where(id: params[:id]).first
    return not_found unless @playlist
  end
end
