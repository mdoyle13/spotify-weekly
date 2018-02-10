class BackupQueuerJob
  include Sidekiq::Worker
  
  def perform(*args)
    User.find_each do |user|
      # don't queue the back up job if this user doesn't have a discover weekly playlist id
      next unless user.discover_weekly_id?
      BackupJob.perform_async user.id 
    end
  end
end
