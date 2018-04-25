# require 'test_helper'
#
# class SpotifyBackupServiceTest < ActiveSupport::TestCase
#   def setup
#     #base spotify service stub out the get spotify user to always just return an empty object
#     BaseSpotifyService.any_instance.stubs(:get_user_from_spotify).returns(true)
#   end
#
#   test "it returns as a failure if playlist cannot be found on spotify" do
#     user = users(:one)
#     service = SpotifyBackupService.new(user)
#
#     # stub the get discover weekly method to fake a nil response from spotify
#     service.expects(:get_discover_weekly).returns(nil)
#
#     # assert that if there's no discover weekly playlist then the service is not successful
#     assert_not service.call.success?
#   end
#
#   test "it doesn't create the playlist on spotify unless user wants it" do
#
#   end
#
#   test "it creates the playlist on spotify if the user wants it" do
#
#   end
# end
