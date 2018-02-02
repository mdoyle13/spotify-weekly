class Playlist < ApplicationRecord
    belongs_to :user
    has_many :tracks
    validate :user_id_and_week_of_is_unique
    validates :spotify_id, uniqueness: {scope: :user}
    

    # set the week of date before creating. the week of date is how to tell 
    # if 'this weeks' discover weekly has been backed up already
    before_create do
        self.week_of = Date.today.at_beginning_of_week
    end

    def get_week_of
        Date.today.at_beginning_of_week
    end

    def week_of_name
        date_string = Date.today.at_beginning_of_week.strftime("%m-%d-%y")
        "Discover Weekly Backup (#{date_string})"
    end

    private
    def user_id_and_week_of_is_unique
        if Playlist.where(user_id: self.user_id, week_of: get_week_of).present?
            errors.add(:week_of, "has already been taken")
        end
    end
end
