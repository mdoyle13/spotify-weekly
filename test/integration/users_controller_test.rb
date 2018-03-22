class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "users cannot edit other users" do
    sign_in users(:two)
    get edit_user_path(users(:one))
    assert_response :not_found
  end
end
