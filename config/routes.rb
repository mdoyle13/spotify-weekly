Rails.application.routes.draw do
  require "sidekiq/web"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    # Protect against timing attacks:
    # - See https://codahale.com/a-lesson-in-timing-attacks/
    # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
    # - Use & (do not use &&) so that it doesn't short circuit.
    # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end

  mount Sidekiq::Web, at: "/sidekiq"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: "sessions" }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#home'

  # spotify auth callback
  get '/auth/spotify/callback', to: 'users#spotify'
  get 'dashboard', to: 'dashboard#index'

  # help page
  get '/help', to: 'pages#help'

  resources :users, only: [:update, :destroy]

  get 'edit_account', to: 'users#edit', as: 'edit_user'

  # namespace :playlists do
  #   resources :spotify_restore, only: :update, as: :post
  # end

  resources :playlists, only: [:show, :destroy] do
    scope module: 'playlists' do
      resource :spotify_restore, only: :create
    end

    post 'initial_discover_weekly_sync', on: :collection

    collection do
      post 'sync_discover_weekly'
    end

  end
end
