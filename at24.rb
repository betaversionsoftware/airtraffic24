require 'mongo'
require 'date'
require 'json'
require 'bunny'

mongo_client = Mongo::Client.new('mongodb://mongo:27017/atr24')
current = mongo_client[:current]
traffic = mongo_client[:traffic]

begin
  conn = Bunny.new(hostname: "mq.airtraffic24.com")
  conn.start
  ch = conn.create_channel
  q = ch.queue("traffic", durable: true)
rescue => e
  sleep(5)
  retry
end

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    json_plane = JSON.parse(body)
    json_plane['last_seen'] ||= DateTime.now

    traffic.insert_one(json_plane)
    current.find_one_and_update({'icao': json_plane['icao']}, {'$set': json_plane, '$inc': {messages: 1}}, { 'upsert': true})
  end
rescue => e
  logger.warn("Duplicate #{e}")
end
