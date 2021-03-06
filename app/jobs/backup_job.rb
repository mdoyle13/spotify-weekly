class BackupJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.where(id: user_id).first
    return unless user.present?

    backup = BackupDiscoverWeekly.call(user: user)

    unless backup.success?
      raise "Backup Failed with message: #{backup.message}"
    end

    return true
  end
end
