class GetPlaylistFromSpotify
  include Interactor

  # context needed #
  # discover_weekly_id

  def call
    # we may already already have it
    return if context.discover_weekly_playlist
    begin
      context.discover_weekly_playlist = RSpotify::Playlist.find("spotify", context.discover_weekly_id)
    rescue RestClient::NotFound
      context.fail!(message: "You need to follow the discover weekly playlist :(")
    end
  end

end
