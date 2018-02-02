class PlaylistsController < ApplicationController
    before_action :authenticate_user!

    def retrieve_discover_weekly
        # Notes: i don't think i need to store this. Maybe store weekly playlist id on the user reocrd
        # and then back that up immediately 
        spotify_service = SpotifyService.new(current_user)

        discover_weekly = spotify_service.get_weekly_playlist
        throw "no discover weekly for this user" unless discover_weekly
        
        current_user.discover_weekly_id = discover_weekly.id
        current_user.save
        redirect_to dashboard_path
    end

    def sync_discover_weekly
        spotify_service = SpotifyService.new(current_user)
        unless spotify_service.sync_discover_weekly
            flash[:error] = "WOhan nelly"
        end
        redirect_to dashboard_path
    end
end
