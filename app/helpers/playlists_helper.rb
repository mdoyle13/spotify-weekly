module PlaylistsHelper
  def track_image_tag(track)
    return false unless track.small_image
    image_tag track.small_image
  end

  def track_embed(track)
    # <iframe src="https://open.spotify.com/embed/track/7702PAEjAWKu3o6e3qgLoc" width="300" height="380" frameborder="0" allowtransparency="true"></iframe>
    content_tag :iframe, nil, src: "https://open.spotify.com/embed/track/#{track.spotify_id}",
      width: "80", height: "80", frameborder: 0, allowtransparency: true
  end
end
