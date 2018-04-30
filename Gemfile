ruby '2.5.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# postgres adapter
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
gem 'sassc-rails', require: false
gem 'webpacker', '~> 3.2'

# bulk import in ar
gem 'activerecord-import', require: false

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# handle user authentication and authorization
gem 'devise'
# add oauth capes
gem 'omniauth'
# spotify omniauth gem
gem 'omniauth-spotify', github: 'mdoyle13/omniauth-spotify'
# spotify wrapper gem
gem 'rspotify', github: "guilhermesad/rspotify"
# process background jobs
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'bootstrap', '~> 4.0.0'
gem 'jquery-rails'
gem "sentry-raven"
gem "interactor"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'dotenv-rails'
  gem 'mocha'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rack-mini-profiler', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# security fixes  #####
gem 'loofah', '= 2.2.2'
gem 'rails-html-sanitizer', '=1.0.4'
########
