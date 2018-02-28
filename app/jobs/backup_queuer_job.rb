class BackupQueuerJob
  include Sidekiq::Worker
  
  def perform(*args)
    User.for_backup_job.find_each do |user|
      BackupJob.perform_async user.id 
    end
  end
end
