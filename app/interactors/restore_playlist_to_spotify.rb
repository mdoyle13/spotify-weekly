class RestorePlaylistToSpotify
  include Interactor::Organizer
  include SpotifyUserContext

  organize CreatePlaylistOnSpotify, AddTracksToPlaylist
end
