class DuplicatePlaylistOnSpotifyTest < ActiveSupport::TestCase

  # test "it fails if the playlist cannot be found" do
  #   RSpotify::Playlist.stubs(:find).raises(RestClient::NotFound)
  #   playlist = GetPlaylistFromSpotify.call(discover_weekly_id: "123")
  #   assert_not playlist.success?
  # end
  #
  # test "it is successful if the playlist is found on spotify" do
  #   RSpotify::Playlist.stubs(:find).returns(true)
  #   playlist = GetPlaylistFromSpotify.call(discover_weekly_id: "123")
  #   assert playlist.success?
  # end
  #
  # test  "it sets the playlist context correctly for the next interactors to use" do
  #   RSpotify::Playlist.stubs(:find).returns(true)
  #   playlist = GetPlaylistFromSpotify.call(discover_weekly_id: "123")
  #   assert playlist.discover_weekly_playlist
  # end
  test "if the user context has auto_sync off it should not proceed" do
    playlist = DuplicatePlaylistOnSpotify.call(user: users(:auto_sync_off))
    assert_not playlist.backup_spotify_playlist
  end
end
