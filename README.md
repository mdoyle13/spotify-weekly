[![Build Status](https://travis-ci.org/mdoyle13/spotify-weekly.svg?branch=master)](https://travis-ci.org/mdoyle13/spotify-weekly)

# README

notes for me

spotify_user = RSpotify::User.new(u.auth_hash)

weekly = spotify_user.playlists.select {|p| p.name == "Discover Weekly"}[0]

tracks = weekly.tracks

playlist = spotify_user.create_playlist!('weekly-backup')

playlist.add_tracks!(tracks)
