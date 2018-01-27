class AddSpotifyTokenFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auth_token, :string
    add_column :users, :refresh_token, :string
  end
end
