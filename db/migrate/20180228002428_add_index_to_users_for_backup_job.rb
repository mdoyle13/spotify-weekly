class AddIndexToUsersForBackupJob < ActiveRecord::Migration[5.1]
  def change
    add_index(:users, [:auto_sync, :discover_weekly_id])
  end
end
