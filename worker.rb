require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

class Message
  include Sidekiq::Worker

  def perform(plane)
    valid_msg = %w(callsign altitude speed lat lng track squawk)
    valid = valid_msg.all? { |v| plane.key?(v) }
    puts plane if valid
  end
end
