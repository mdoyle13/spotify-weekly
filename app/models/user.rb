class User < ApplicationRecord
  has_many :playlists, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :timeoutable
  store_accessor :auth_hash, :info
      
  def self.from_omniauth(auth)
    # find or create the record
    record = where(email: auth.info.email).first_or_create

    # update the attrs
    record.update_attributes(
        password: Devise.friendly_token.first(8),
        provider: auth.provider,
        uid: auth.uid,
        auth_hash: auth.to_hash,
        auth_token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token,
      )

    record
  end

  
    # load the playlist id off the user
    # get it from spotify
    # load the tracks
    # create new playlist on spotify for the user effectively backing it up
    # store the playlist in db
    # store the tracks in db



    # pl = current_user.playlists.where(spotify_id: discover_weekly.id, name: "Discover Weekly")
        #     .first_or_create

        # create the tracks
        # discover_weekly.tracks.each do |track|
        #    pl.tracks.create(spotify_id: track.id, data: track)
        # end
  


  def has_discover_weekly?
    self.discover_weekly_id.present?
  end
end
