require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "has_discover_weekly? returns true if the user record has this data" do 
    user = users(:one)
    assert user.has_discover_weekly?
  end

  test "has_disocver_weekly? returns false if the user does not have this field" do
    user = users(:no_weekly)
    assert_not user.has_discover_weekly?
  end

  test "has_backups? returns true if the user has any playlist records attached" do 
    user = users(:one)
    assert user.has_backups?
  end

  test "has_backups? returns false if the user does not have any" do
    user = users(:no_backups)
    assert_not user.has_backups?
  end

end
