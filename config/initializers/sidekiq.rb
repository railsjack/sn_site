require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.failures_max_count = 500
  config.poll_interval = 2
  config.redis = { password: Rails.application.secrets.redis_pass }
end

Sidekiq.configure_client do |config|
  config.redis = { password: Rails.application.secrets.redis_pass }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["admin", "T1s+ohX;oGtQv}~]W2~eM$Kk*"]
end if Rails.env.staging? or Rails.env.production?