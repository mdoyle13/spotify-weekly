class RemoveDupePlaylistsJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    spotify_user = RSpotify::User.new(user.auth_hash)
    return unless spotify_user
    
    #find all the stupid dupes for 6-25
    dupe_name = "ReDiscover Weekly (06-25-18)"
    
    
    dupes = []
    playlists = []
    
    offset = 0
    loop do
      _playlists = spotify_user.playlists(limit: 50, offset: offset)
      break if _playlists.count == 0
      playlists << _playlists
      offset += 50
    end
    playlists.flatten!
    
    dupes = playlists.select do |pl|
      pl.name == dupe_name
    end
    
    return unless dupes
    
    # remove the first element from the array
    dupes_to_delete = dupes.drop(1)
    
    dupes_to_delete.each do |dupe|
      spotify_user.unfollow(dupe)
    end
    
    return true
  end
end
