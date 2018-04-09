require 'test_helper'

class SpotifyWeeklyPlaylistServiceTest < ActiveSupport::TestCase
  test "it is unsuccessful if the user is not following the discover weekly playlist" do
    # stub the spotify_user attribute getter method to just return a new object so we can proceed
    BaseSpotifyService.any_instance.stubs(:spotify_user).returns(Object.new)
    
    user = users(:one)
    service = SpotifyWeeklyPlaylistService.new(user)
    
    service.expects(:get_all_playlists).returns([])
  
    # assert that if there's no discover weekly playlist then the service is not successful 
    assert_not service.call.success?
  end
end