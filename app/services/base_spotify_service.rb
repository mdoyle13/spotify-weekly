class BaseSpotifyService
  attr_accessor :spotify_user, :user_record, :response

  def initialize(user)
    @user_record = user
    @response = OpenStruct.new(success?: false, message: nil)
  end

  def call
    get_user_from_spotify
  end

  private
  def get_user_from_spotify
    @spotify_user = RSpotify::User.new(user_record.auth_hash)
  end
  
  def fail!(msg: )
    response.message = msg
    return response
  end
end