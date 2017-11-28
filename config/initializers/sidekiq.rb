# frozen_string_literal: true

if production?
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['BUILDCAUHINH_REDIS_URL'], namespace: ENV['BUILDCAUHINH_REDIS_NAMESPACE'] }
  end

  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['BUILDCAUHINH_REDIS_URL'], namespace: ENV['BUILDCAUHINH_REDIS_NAMESPACE'] }
  end
end
