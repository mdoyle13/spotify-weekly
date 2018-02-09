class PlaylistsController < ApplicationController
    before_action :authenticate_user!

    def retrieve_discover_weekly
      # this method will be called when a user needs to manually attach the weekly id

      @spotify_weekly_playlist_service = SpotifyWeeklyPlaylistService.new(current_user).call
      
      if @spotify_weekly_playlist_service.success?
        current_user.discover_weekly_id = @spotify_weekly_playlist_service.playlist.id
        current_user.save
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
end
