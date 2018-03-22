class PlaylistsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "non logged in users cannot view playlists" do
    get playlist_path(playlists(:one))
    assert_response :redirect
  end

  test "users cannot view playlists that are not theirs" do
    sign_in users(:one)
    get playlist_path(playlists(:two))
    assert_response :not_found
  end

  test "users can view their own playlists" do
    sign_in users(:two)
    get playlist_path(playlists(:two))
    assert_response :success
  end
end
