require 'test_helper'

class SpotifyBackupServiceTest < ActiveSupport::TestCase
  test "it returns as a failure if playlist cannot be found on spotify" do
    #base spotify service stub out the get spotify user to always just return an empty object
    BaseSpotifyService.any_instance.stubs(:get_user_from_spotify).returns(true)
    
    user = users(:one)
    service = SpotifyBackupService.new(user)
    
    # stub the get discover weekly method to fake a nil response from spotify
    service.expects(:get_discover_weekly).returns(nil)
    
    # assert that if there's no discover weekly playlist then the service is not successful 
    assert_not service.call.success?
  end
end