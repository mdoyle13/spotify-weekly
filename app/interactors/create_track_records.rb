require 'activerecord-import/base'
require 'activerecord-import/active_record/adapters/postgresql_adapter'

class CreateTrackRecords
  include Interactor

  # needed context
  # db_playlist

  def call
    Track.import build_tracks, validate: true
  end

  private
  def build_tracks
    context.discover_weekly_playlist.tracks.map do |track|
      context.db_playlist.tracks.build(spotify_id: track.id, data: track)
    end
  end
end
