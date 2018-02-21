require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpotifyWeekly
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Rspotify setup
    RSpotify::authenticate("f006a0d2f05540c6844a6c65abc104d6", "c1ecc2faa2f74021bd9d9bc7a4954d78")
      
    unless Rails.env.development? || Rails.env.test?
      Raven.configure do |config|
        config.dsn = ENV['SENTRY_DSN']
      end
    end

    # specify the background job system we want to use
    config.active_job.queue_adapter = :sidekiq

    # because when we check for beginning of week it needs to be right
    config.time_zone = "Central Time (US & Canada)"
    
    # add the fonts into the pipeline
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
  end
end
