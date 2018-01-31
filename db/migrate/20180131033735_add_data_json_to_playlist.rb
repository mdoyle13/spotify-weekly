class AddDataJsonToPlaylist < ActiveRecord::Migration[5.1]
  def change
    add_column :playlists, :data, :json
  end
end
