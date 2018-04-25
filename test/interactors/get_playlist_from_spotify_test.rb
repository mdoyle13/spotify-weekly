class GetPlaylistFromSpotifyTest < ActiveSupport::TestCase

  test "it fails if the playlist cannot be found" do
    RSpotify::Playlist.stubs(:find).raises(RestClient::NotFound)
    playlist = GetPlaylistFromSpotify.call(discover_weekly_id: "123")
    assert_not playlist.success?
  end

  test "it is successful if the playlist is found on spotify" do
    RSpotify::Playlist.stubs(:find).returns(true)
    playlist = GetPlaylistFromSpotify.call(discover_weekly_id: "123")
    assert playlist.success?
  end
  
end
