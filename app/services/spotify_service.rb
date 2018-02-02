class SpotifyService
    def initialize(user)
        @user_record = user
        @spotify_user = RSpotify::User.new(user.auth_hash)
    end

    def get_weekly_playlist
        playlist = @spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
        # will return nil if no playlist found
    end

    def sync_discover_weekly
        spotify_playlist = get_weekly_playlist
        tracks = spotify_playlist.tracks
        db_playlist = @user_record.playlists.new

        name = db_playlist.week_of_name

        backup_playlist = @spotify_user.create_playlist!(name)
        backup_playlist.add_tracks!(tracks)

        db_playlist.tap do |pl|
            pl.name = name
            pl.spotify_id = backup_playlist.id
            pl.data = backup_playlist
        end

        return false unless db_playlist.save
        
        # reverse the tracks so they are created in the same order as on spotify?
        tracks.reverse.each do |track|
           db_playlist.tracks.create(spotify_id: track.id, data: track)
        end

        return true
    end
end