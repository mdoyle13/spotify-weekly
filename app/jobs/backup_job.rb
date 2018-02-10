class BackupJob
  include Sidekiq::Worker
  
  def perform(user_id)
    user = User.where(id: user_id).first
    return unless user.present?
    
    backup = SpotifyBackupService.new(user).call

    unless backup.success?
      raise "Backup Failed with message: #{backup.message}"
    end

    return true
  end
end
