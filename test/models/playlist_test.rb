require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  
  test "should not save with non unique user id and week of" do
    user = users(:one)
    playlist = user.playlists.first
    # try to save a new playlist with a matching week of as the current users first playlist
    new_playlist = user.playlists.new(week_of: playlist.week_of)
    # validation should fail
    assert_not new_playlist.save
  end

end
