require 'test_helper'

class SpotifyUserContextTest < ActiveSupport::TestCase
    class DummyInteractor
      include Interactor
      include SpotifyUserContext
  end

  test "it fails if no spotify user is present?" do
    DummyInteractor.stubs(:context).returns(Interactor::Context.new)
    RSpotify::User.expects(:new).returns(Exception)
    assert_not DummyInteractor.call.success?
  end
end
