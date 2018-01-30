class CreatePlaylists < ActiveRecord::Migration[5.1]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :spotify_id
      t.integer :user_id
      t.timestamps
    end
    add_index :playlists, :user_id
  end
end
