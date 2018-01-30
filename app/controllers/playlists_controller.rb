class PlaylistsController < ApplicationController
    before_action :authenticate_user!


    def initial_weekly_sync
        # Notes: i don't think i need to store this. Maybe store weekly playlist id on the user reocrd
        # and then back that up immediately 
        spotify_service = SpotifyService.new(current_user)

        discover_weekly = spotify_service.get_weekly_playlist
        throw "no discover weekly for this user" unless discover_weekly

        
        current_user.update_attributes(discover_weekly_id: discover_weekly.id)

        # pl = current_user.playlists.where(spotify_id: discover_weekly.id, name: "Discover Weekly")
        #     .first_or_create

        # create the tracks
        # discover_weekly.tracks.each do |track|
        #    pl.tracks.create(spotify_id: track.id, data: track)
        # end
    end
end
