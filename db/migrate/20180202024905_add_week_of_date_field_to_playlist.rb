class AddWeekOfDateFieldToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :week_of, :date
  end
end
