require 'sidekiq'
Sidekiq.configure_server do |config|
    config.redis = { url: Settings.sidekiq.redis, namespace: "cengke_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
    config.redis = { url: Settings.sidekiq.redis, namespace: "cengke_#{Rails.env}" }
end

Sidekiq.default_worker_options = { retry: 3 }
