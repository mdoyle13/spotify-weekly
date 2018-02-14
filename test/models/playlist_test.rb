require 'test_helper'

class PlaylistTest < ActiveSupport::TestCase
  
  test "should not save with non unique user id and week of" do
    user = users(:one)
    playlist = user.playlists.first
    new_playlist = user.playlists.new(week_of: playlist.week_of)

    assert_not new_playlist.save
  end

end
