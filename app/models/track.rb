class Track < ApplicationRecord
    store_accessor :data, :name, :id, :album
    belongs_to :playlist
end
