require 'sidekiq'
require 'mongo'
require 'date'
require 'json'
require 'active_support/all'

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/1' }
end

class Message
  include Sidekiq::Worker

  @@mongo_client = Mongo::Client.new('mongodb://mongo:27017/atr24')
  @@current = @@mongo_client[:current]
  @@traffic = @@mongo_client[:traffic]

  def perform(plane)
    json_plane = JSON.parse(plane)
    json_plane['last_seen'] ||= DateTime.now

    @@traffic.insert_one(json_plane)

    @@current.find_one_and_update({'icao': json_plane['icao']}, {'$set': json_plane, '$inc': {messages: 1}}, { 'upsert': true})
  end
end
