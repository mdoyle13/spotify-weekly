Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'
  # spotify auth callback
  get '/auth/spotify/callback', to: 'users#spotify'
  get 'dashboard', to: 'dashboard#index'
  

  resource :playlists, only: [] do
    post 'retrieve_discover_weekly', on: :collection
    post 'sync_discover_weekly'
  end
end
