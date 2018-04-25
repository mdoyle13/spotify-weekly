module SpotifyUserContext
  extend ActiveSupport::Concern

  included do
    around do |interactor|
      begin
        context.spotify_user = RSpotify::User.new(context.user.auth_hash)
      rescue => e
        puts e
        context.fail!(message: "Couldn't find user on spotify")
      end
      interactor.call
    end
  end
end
