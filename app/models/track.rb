class Track < ApplicationRecord
    store_accessor :data, :name, :id, :album, :artists
    belongs_to :playlist

    def formatted_artist_name
        artists.map {|a| a["name"] }.join(", ")
    end
end
