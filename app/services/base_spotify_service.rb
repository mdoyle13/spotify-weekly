class BaseSpotifyService
  attr_accessor :spotify_user, :user_record, :response

  def initialize(user)
    @user_record = user
    @response = OpenStruct.new(success?: false, message: nil)
  end

  def call
    # returns a spotify user object
    @spotify_user = RSpotify::User.new(user_record.auth_hash)
  end

  private

  def fail!(msg: )
    response.message = msg
    return response
  end
end