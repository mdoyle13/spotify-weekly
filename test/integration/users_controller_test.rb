class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "users cannot edit other users" do
    sign_in users(:two)
    # try to update a different user, user 1
    put user_path(users(:one)), params: { user: {email: "changeme@aol.com"}, format: 'js' }
    assert_response :error
  end

  test "users can edit themselves" do
    sign_in users(:one)
    put user_path(users(:one)), params: { user: {email: "changeme@aol.com"}, format: 'js' }
    assert_response :success
  end
end
