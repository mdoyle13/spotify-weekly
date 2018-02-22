class Track < ApplicationRecord
  store_accessor :data, :name, :id, :artists
  belongs_to :playlist

  def formatted_artist_name
    artists.map {|a| a["name"] }.join(", ")
  end

  def images
    data.dig("album", "images").collect { |i| i["url"] } rescue []
  end

  def small_image
    images.last
  end

  def large_image
    images.first
  end
end
