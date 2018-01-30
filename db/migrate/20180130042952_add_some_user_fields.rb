class AddSomeUserFields < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :discover_weekly_id, :string
    add_column :users, :auto_sync, :boolean, default: true
  end
end
