class Playlist < ApplicationRecord
  belongs_to :user
  has_many :tracks, dependent: :destroy
  # only validate on create
  validate :user_id_and_week_of_is_unique, on: [:create] 

  # set the week of date before creating. the week of date is how to tell
  # if 'this weeks' discover weekly has been backed up already
  before_create do
    self.week_of = Time.zone.now.to_date.at_beginning_of_week
  end

  def self.this_week_backup_name
    date_string = Time.zone.now.to_date.at_beginning_of_week.strftime("%m-%d-%y")
    "ReDiscover Weekly (#{date_string})"
  end

  def update_with_spotify(spotify_playlist)
    self.tap do |pl|
      pl.spotify_id = spotify_playlist.id
      pl.data = spotify_playlist
    end

    self.save
    self
  end

  private
    def get_week_of
       Time.zone.now.to_date.at_beginning_of_week
    end

    def user_id_and_week_of_is_unique
      if Playlist.where(user_id: self.user_id, week_of: get_week_of).present?
          errors.add(:base, "Already backed up your discover weekly this week.
              you can restore it to spotify if you need to though.")
      end
    end
end
