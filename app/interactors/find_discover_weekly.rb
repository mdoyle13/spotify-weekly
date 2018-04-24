class FindDiscoverWeekly
  include Interactor

  def call
    # if the user already has the discover_weekly_id we don't need to continue
    return if context.user.discover_weekly_id

    discover_weekly_playlist = find_weekly_playlist

    unless discover_weekly_playlist
      context.fail!(message: "You are not following Discover Weekly. Once you do that come back and try again")
    end

    context.user.update_attributes(discover_weekly_id: discover_weekly_playlist.id)
    context.discover_weekly_playlist = discover_weekly_playlist
  end

  private

  def find_weekly_playlist
    playlist = get_all_playlists.select {|p| p.name == "Discover Weekly"}[0]
  end

  #TODO FIX ME: this could get crazy if a user has a ton of playlists.
  def get_all_playlists
    playlists = []
    offset = 0
    loop do
      _playlists = context.spotify_user.playlists(limit: 50, offset: offset)
      break if _playlists.count == 0
      playlists << _playlists
      offset += 50
    end
    playlists.flatten
  end
end
