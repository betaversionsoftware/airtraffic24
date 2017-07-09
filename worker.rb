require 'sidekiq'
require 'mongo'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

class Message
  include Sidekiq::Worker

  @traffic = nil

  def initialize
    mongo_client = Mongo::Client.new([ 'mongo:27017' ], :database => 'airtraffic24')
    @traffic = mongo_client[:traffic]
  end

  def perform(plane)
    valid_msg = %w(icao callsign altitude speed lat lng track squawk)
    valid = valid_msg.all? { |v| plane.key?(v) }
    @traffic.insert_one(plane) if valid
  end
end
