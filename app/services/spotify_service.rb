class SpotifyService
    def initialize(user)
        @user_record = user
        @response = OpenStruct.new(success?: false, message: nil)

        # oauth with spotify
        begin
            @spotify_user = RSpotify::User.new(user.auth_hash)
        rescue
            @response.send("success?=", false)
            @response.message = "there was a problem authenticating with spotify please try again later"
            return @response
        end
    end

    def call
      sync_discover_weekly
    end
    
    private
    def sync_discover_weekly
      spotify_playlist = get_weekly_playlist
      tracks = spotify_playlist.tracks
      db_playlist = @user_record.playlists.new

      # check this so we dont create dupes of the spotify playlist
      unless db_playlist.valid?
         @response.message = db_playlist.errors.full_messages.to_sentence
         return @response
      end

      name = db_playlist.week_of_name

      backup_playlist = @spotify_user.create_playlist!(name)
      backup_playlist.add_tracks!(tracks)

      db_playlist.tap do |pl|
          pl.name = name
          pl.spotify_id = backup_playlist.id
          pl.data = backup_playlist
      end

      unless db_playlist.save
        @response.message = db_playlist.errors.full_messages.to_sentence
        return @response
      end

      # reverse the tracks so they are created in the same order as on spotify?
      tracks.reverse.each do |track|
         db_playlist.tracks.create(spotify_id: track.id, data: track)
      end

      @response.send("success?=", true)
      @response.message = "Huzzah - your Discover Weekly playlist is backed up"
      return @response
      
  end


    def get_weekly_playlist
        playlist = @spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]
        # will return nil if no playlist found
    end
end