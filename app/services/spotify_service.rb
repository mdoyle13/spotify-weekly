class SpotifyService
    def initialize(user)
        @spotify_user = RSpotify::User.new(user.auth_hash)
    end

    def get_weekly_playlist
        playlist = @spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
        # will return nil if no playlist found
    end

    def get_tracks(playlist)
        tracks = playlist.tracks
    end
end