class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :spotify_id
      t.json :data
      t.integer :playlist_id

      t.timestamps
    end

    add_index :tracks, :playlist_id
  end
end
