class Playlist < ApplicationRecord
    belongs_to :user
    has_many :tracks
    validates :spotify_id, uniqueness: {scope: :user}

    def week_of_name
        date_string = Date.today.at_beginning_of_week.strftime("%m-%d-%y")
        "Discover Weekly Backup (#{date_string})"
    end
end
