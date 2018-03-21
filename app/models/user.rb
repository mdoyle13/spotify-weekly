class User < ApplicationRecord
  has_many :playlists, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :trackable, :timeoutable, :rememberable
  store_accessor :auth_hash, :info
  validates :email, uniqueness: true

  scope :with_auto_sync_enabled, -> { where(auto_sync: true) }
  scope :with_discover_weekly, -> { where.not(discover_weekly_id: nil) }

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

  def self.for_backup_job
    with_discover_weekly
  end

    def has_discover_weekly?
    self.discover_weekly_id.present?
  end

  def has_this_week_backup?
    !playlists.new.valid?
  end

  def has_backups?
    playlists.count > 0
  end

  def image_url
    info["image"]
  end
end
