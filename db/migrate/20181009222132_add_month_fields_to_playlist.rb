class AddMonthFieldsToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :month_of, :datetime
  end
end
