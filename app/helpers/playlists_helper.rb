module PlaylistsHelper
  def track_image_tag(track)
    return false unless track.small_image
    content_tag :a, nil, href: "//open.spotify.com/track/#{track.spotify_id}", target: "_blank" do
      image_tag track.small_image
    end
  end
end
