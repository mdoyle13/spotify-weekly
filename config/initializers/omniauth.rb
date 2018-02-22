OmniAuth.config.full_host = lambda do |env|
  ENV['OMNIAUTH_FULL_HOST'] || "http://localhost:3000"
end